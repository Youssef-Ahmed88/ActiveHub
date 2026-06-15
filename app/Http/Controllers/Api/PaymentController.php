<?php

namespace App\Http\Controllers\Api;

use App\Helpers\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class PaymentController extends Controller
{
    public function index()
    {
        return ApiResponse::success(
            Payment::with('booking')->get(),
            'Payments retrieved successfully'
        );
    }

    public function show(Payment $payment)
    {
        return ApiResponse::success(
            $payment->load('booking'),
            'Payment retrieved successfully'
        );
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'booking_id'       => 'required|exists:bookings,id',
            'transaction_id'   => 'nullable|string|unique:payments,transaction_id',
            'amount'           => 'required|numeric|min:0',
            'payment_method'   => 'required|string',
            'paid_at'          => 'nullable|date',
        ]);

        $payment = Payment::create($validated);

        // ✅ بعد إنشاء الـ payment، غير الـ booking status لـ confirmed
        $booking = Booking::find($validated['booking_id']);
        if ($booking) {
            $booking->update(['status' => 'confirmed']);
            Log::info("Booking {$booking->id} confirmed after payment");
        }

        return ApiResponse::success($payment, 'Payment created successfully', 201);
    }
}
