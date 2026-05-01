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

class ChatbotController extends Controller
{
    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string|max:500',
        ]);

        $userMessage = $request->message;

        $sports = Sport::all(['id', 'name'])->toArray();
        $courts = Court::all(['id', 'name', 'sport_id', 'price_per_hour', 'address'])->toArray();
        $slots  = TimeSlot::where('is_available', true)->get(['court_id', 'slot_date', 'start_time', 'end_time'])->toArray();

        $sportsText = collect($sports)->map(fn($s) => $s['name'])->join(', ');
        $courtsText = collect($courts)->map(fn($c) =>
            "- اسم الملعب: {$c['name']} | السعر: {$c['price_per_hour']} جنيه/ساعة | العنوان: {$c['address']}"
        )->join("\n");
        $slotsText  = collect($slots)->map(fn($s) =>
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

        المواعيد الفاضية الحقيقية من قاعدة البيانات:
        {$slotsText}

        سؤال المستخدم: {$userMessage}

        قواعد مهمة:
        - رد باللغة العربية فقط
        - لا تخترع مواعيد أو أسعار أو عناوين
        - البيانات المذكورة أعلاه هي المصدر الوحيد للمعلومات
        - لو المعلومة موجودة في البيانات، اذكرها
        - كن مختصراً ومفيداً
        ";

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('GROQ_API_KEY'),
            'Content-Type'  => 'application/json',
        ])->post('https://api.groq.com/openai/v1/chat/completions', [
            'model'    => 'llama-3.3-70b-versatile',
            'messages' => [
                ['role' => 'user', 'content' => $prompt]
            ],
        ]);

        $botReply = $response->json()['choices'][0]['message']['content'] ?? 'عفواً، حدث خطأ.';

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