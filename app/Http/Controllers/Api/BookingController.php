<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\TimeSlot;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class BookingController extends Controller
{
    // GET /api/my-bookings
    // Returns all bookings of the logged-in user
    public function myBookings()
    {
        return Booking::with('court')
            ->where('user_id', Auth::id())
            ->get();
    }

    // POST /api/bookings
    // Creates a new booking using a time_slot_id
    public function store(Request $request)
    {
        // 1. Validate the request
        $request->validate([
            'time_slot_id' => 'required|exists:time_slots,id',
            'court_id'     => 'required|exists:courts,id',
        ]);

        // 2. Find the time slot
        $timeSlot = TimeSlot::findOrFail($request->time_slot_id);

        // 3. Check that the time slot belongs to the given court
        if ($timeSlot->court_id != $request->court_id) {
            return response()->json([
                'success' => false,
                'message' => 'Time slot does not belong to this court'
            ], 422);
        }

        // 4. Check if the time slot is still available
        if (!$timeSlot->is_available) {
            return response()->json([
                'success' => false,
                'message' => 'This time slot is already booked'
            ], 409);
        }

        // 5. Prevent double booking (extra safety)
        if (Booking::where('time_slot_id', $timeSlot->id)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Slot already booked'
            ], 400);
        }

        // 6. Calculate total price
        $court = \App\Models\Court::findOrFail($request->court_id);
        
        // Combine slot_date with start_time to create full DATETIME
        $start = Carbon::parse($timeSlot->slot_date . ' ' . $timeSlot->start_time);
        $end   = Carbon::parse($timeSlot->slot_date . ' ' . $timeSlot->end_time);
        
        $hours = $start->diffInHours($end);
        $total_price = $hours * $court->price_per_hour;

        // 7. Create the booking (with full datetime for start_time and end_time)
        $booking = Booking::create([
            'user_id'      => Auth::id(),
            'court_id'     => $request->court_id,
            'time_slot_id' => $timeSlot->id,
            'start_time'   => $start,       // Full datetime: YYYY-MM-DD HH:MM:SS
            'end_time'     => $end,         // Full datetime
            'total_price'  => $total_price,
            'status'       => 'confirmed',
        ]);

        // 8. Mark the time slot as not available
        $timeSlot->update(['is_available' => false]);

        // 9. Return success response
        return response()->json([
            'success' => true,
            'message' => 'Booking created successfully',
            'data'    => $booking
        ], 201);
    }

    // DELETE /api/bookings/{id}
    // Cancels a booking and makes the time slot available again
    public function destroy(int $id)
    {
        $booking = Booking::findOrFail($id);

        // Only the owner of the booking can cancel it
        if ($booking->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Make the time slot available again using the stored time_slot_id
        TimeSlot::where('id', $booking->time_slot_id)
            ->update(['is_available' => true]);

        $booking->delete();

        return response()->json([
            'success' => true,
            'message' => 'Booking cancelled'
        ]);
    }
}