<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\TimeSlot;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class BookingController extends Controller
{
    // GET /api/my-bookings
    public function myBookings()
    {
        return Booking::with('court')
            ->where('user_id', Auth::id())
            ->get();
    }

    // POST /api/bookings
    public function store(Request $request)
    {
        $request->validate([
            'court_id' => 'required|exists:courts,id',
            'start_time' => 'required',
            'end_time' => 'required',
        ]);

        // 🔥 Check double booking
        $exists = Booking::where('court_id', $request->court_id)
            ->where(function ($q) use ($request) {
                $q->whereBetween('start_time', [$request->start_time, $request->end_time])
                  ->orWhereBetween('end_time', [$request->start_time, $request->end_time]);
            })->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Slot already booked'
            ], 400);
        }

        // create booking
        $booking = Booking::create([
            'user_id' => Auth::id(),
            'court_id' => $request->court_id,
            'start_time' => $request->start_time,
            'end_time' => $request->end_time,
            'status' => 'confirmed'
        ]);

        // ❗ update timeslot availability
        TimeSlot::where('court_id', $request->court_id)
            ->where('start_time', $request->start_time)
            ->update(['is_available' => false]);

        return response()->json($booking, 201);
    }

    // DELETE /api/bookings/{id}
    public function destroy($id)
    {
        $booking = Booking::findOrFail($id);

        if ($booking->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // رجع الـ slot متاح تاني
        TimeSlot::where('court_id', $booking->court_id)
            ->where('start_time', $booking->start_time)
            ->update(['is_available' => true]);

        $booking->delete();

        return response()->json(['message' => 'Booking cancelled']);
    }
}