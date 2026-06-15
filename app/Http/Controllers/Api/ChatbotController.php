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
    private array $sensitivePatterns = [
        '/\b\d{16}\b/',
        '/\b\d{4}[\s-]\d{4}[\s-]\d{4}[\s-]\d{4}\b/',
        '/\bcvv\b|\bcvc\b/i',
        '/\bpin\b/i',
    ];

    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string|max:500',
        ]);

        $userMessage = $request->message;

        foreach ($this->sensitivePatterns as $pattern) {
            if (preg_match($pattern, $userMessage)) {
                return response()->json([
                    'success' => false,
                    'message' => 'لا ترسل بيانات حساسة مثل أرقام البطاقات.',
                    'data'    => null,
                ], 400);
            }
        }

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
            $response = Http::timeout(30)
                ->withOptions(['verify' => false])
                ->withHeaders([
                    'Authorization' => 'Bearer ' . config('services.groq.api_key'),
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
