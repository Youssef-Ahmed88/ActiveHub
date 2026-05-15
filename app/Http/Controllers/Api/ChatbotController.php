<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ChatbotLog;
use App\Models\Court;
use App\Models\Sport;
use App\Models\TimeSlot;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class ChatbotController extends Controller
{
    // أنماط البيانات الحساسة التي يجب حظرها
    private array $sensitivePatterns = [
        '/\b\d{16}\b/',                    // أرقام بطاقات الائتمان
        '/\b\d{4}[\s-]\d{4}[\s-]\d{4}[\s-]\d{4}\b/', // بطاقة بصيغة أخرى
        '/\bcvv\b|\bcvc\b/i',              // CVV/CVC
        '/\bpassword\b|\bكلمة المرور\b/i', // كلمات المرور
        '/\bpin\b|\bرقم سري\b/i',          // PIN
        '/\b\d{3}\b.*\b(cvv|cvc)\b/i',    // رقم CVV
    ];

    // الأسئلة التي تحاول استخراج بيانات مستخدمين آخرين
    private array $privacyViolationPatterns = [
        '/بيانات.*مستخدم/i',
        '/معلومات.*حساب.*آخر/i',
        '/credit.*card.*user/i',
        '/show.*user.*data/i',
        '/get.*user.*password/i',
        '/بطاقة.*شخص/i',
        '/حساب.*شخص.*آخر/i',
    ];

    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string|max:500',
        ]);

        $userMessage = $request->message;

        // 1. فحص البيانات الحساسة في الرسالة
        foreach ($this->sensitivePatterns as $pattern) {
            if (preg_match($pattern, $userMessage)) {
                Log::warning('Sensitive data attempt in chatbot', [
                    'user_id' => Auth::id(),
                    'message_length' => strlen($userMessage),
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'لا ترسل بيانات حساسة مثل أرقام البطاقات أو كلمات المرور. بياناتك الشخصية يجب أن تظل سرية.',
                    'data'    => null,
                ], 400);
            }
        }

        // 2. فحص محاولات الوصول لبيانات مستخدمين آخرين
        foreach ($this->privacyViolationPatterns as $pattern) {
            if (preg_match($pattern, $userMessage)) {
                Log::warning('Privacy violation attempt in chatbot', [
                    'user_id' => Auth::id(),
                    'pattern_matched' => $pattern,
                ]);

                return response()->json([
                    'success' => false,
                    'message' => 'لا يمكنك الوصول إلى بيانات مستخدمين آخرين. كل مستخدم يرى بياناته فقط.',
                    'data'    => null,
                ], 403);
            }
        }

        // 3. فحص طول الرسالة المشبوهة
        if (strlen($userMessage) > 300) {
            Log::warning('Suspiciously long chatbot message', [
                'user_id' => Auth::id(),
                'length'  => strlen($userMessage),
            ]);
        }

        // جلب البيانات الحقيقية من DB
        $sports = Sport::all(['id', 'name'])->toArray();
        $courts = Court::limit(10)->get(['id', 'name', 'sport_id', 'price_per_hour', 'address'])->toArray();
        $slots  = TimeSlot::where('is_available', true)->limit(20)->get(['court_id', 'slot_date', 'start_time', 'end_time'])->toArray();

        $sportsText = collect($sports)->map(fn($s) => $s['name'])->join(', ');
        $courtsText = collect($courts)->map(fn($c) =>
            "- اسم الملعب: {$c['name']} | السعر: {$c['price_per_hour']} جنيه/ساعة | العنوان: {$c['address']}"
        )->join("\n");
        $slotsText = collect($slots)->map(fn($s) =>
            "ملعب رقم {$s['court_id']}: {$s['slot_date']} من {$s['start_time']} لـ {$s['end_time']}"
        )->join("\n");

        $prompt = "
        أنت مساعد ذكي لتطبيق ActiveHub لحجز الملاعب الرياضية في مصر.
        يجب أن ترد دائماً باللغة العربية الفصحى فقط.
        لا تخترع أي معلومات - استخدم فقط البيانات المتاحة أدناه.
        إذا كانت المعلومات موجودة في البيانات أدناه، يجب أن تذكرها.

        قواعد الخصوصية والأمان (مهم جداً):
        - لا تشارك أي بيانات شخصية لأي مستخدم مع مستخدم آخر
        - لا تذكر أي معلومات عن بطاقات الائتمان أو كلمات المرور
        - إذا سأل المستخدم عن بيانات شخصية لمستخدم آخر، ارفض بشكل قاطع
        - أنت تعمل فقط على بيانات الملاعب والحجوزات العامة

        الرياضات المتاحة: {$sportsText}

        الملاعب المتاحة مع عناوينها:
        {$courtsText}

        المواعيد الفاضية الحقيقية من قاعدة البيانات (عينة):
        {$slotsText}

        سؤال المستخدم: {$userMessage}

        قواعد مهمة:
        - رد باللغة العربية فقط
        - لا تخترع مواعيد أو أسعار أو عناوين
        - البيانات المذكورة أعلاه هي المصدر الوحيد للمعلومات
        - لو المعلومة موجودة في البيانات، اذكرها
        - كن مختصراً ومفيداً (لا تزيد ردك عن 3 جمل)
        - لا تشارك بيانات شخصية أو مالية لأي مستخدم
        ";

        try {
            $response = Http::timeout(30)->withHeaders([
                'Authorization' => 'Bearer ' . env('GROQ_API_KEY'),
                'Content-Type'  => 'application/json',
            ])->post('https://api.groq.com/openai/v1/chat/completions', [
                'model'    => 'llama-3.3-70b-versatile',
                'messages' => [
                    ['role' => 'user', 'content' => $prompt]
                ],
            ]);

            if ($response->failed()) {
                Log::error('Groq API error: ' . $response->body());
                $botReply = 'عذراً، خدمة المساعد مشغولة حالياً. حاول مرة أخرى.';
            } else {
                $botReply = $response->json()['choices'][0]['message']['content'] ?? 'عفواً، لم أفهم السؤال.';
            }
        } catch (\Exception $e) {
            Log::error('Groq exception: ' . $e->getMessage());
            $botReply = 'حدث خطأ في الاتصال بالمساعد الذكي. الرجاء المحاولة لاحقاً.';
        }

        // تسجيل المحادثة
        ChatbotLog::create([
            'user_id'  => Auth::id(),
            'query'    => $userMessage,
            'response' => $botReply,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Chatbot response',
            'data'    => [
                'reply' => $botReply,
            ],
        ]);
    }
}