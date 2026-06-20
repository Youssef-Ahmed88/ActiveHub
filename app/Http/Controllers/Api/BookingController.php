<?php
 
namespace App\Http\Controllers\Api;
 
use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\TimeSlot;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
 
class BookingController extends Controller
{
    // GET /api/my-bookings
    public function myBookings()
    {
        return Booking::with('court')
            ->where('user_id', Auth::id())
            ->get();
    }
 
    // GET /api/owner/bookings
    public function ownerBookings()
    {
        $ownerId = Auth::id();
 
        $bookings = Booking::with(['court', 'court.sport', 'user'])
            ->whereHas('court', function ($query) use ($ownerId) {
                $query->where('owner_id', $ownerId);
            })
            ->orderBy('created_at', 'desc')
            ->get();
 
        return response()->json([
            'success' => true,
            'data'    => $bookings
        ]);
    }

    //  PATCH /api/bookings/{id}/confirm
    public function confirm(int $id)
    {
        $booking = Booking::with('court.sport')->findOrFail($id);

        if ($booking->user_id !== Auth::id()) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $booking->update(['status' => 'confirmed']);

        Notification::create([
            'user_id'    => Auth::id(),
            'message'    => "Your booking at {$booking->court->name} has been confirmed! ",
            'sport_type' => $booking->court->sport?->name ?? 'Sport',
            'is_read'    => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Booking confirmed successfully',
            'data'    => $booking
        ]);
    }
 
    // POST /api/bookings
    public function store(Request $request)
    {
        $request->validate([
            'time_slot_id' => 'required|exists:time_slots,id',
            'court_id'     => 'required|exists:courts,id',
        ]);
 
        $timeSlot = TimeSlot::findOrFail($request->time_slot_id);
 
        if ($timeSlot->court_id != $request->court_id) {
            return response()->json([
                'success' => false,
                'message' => 'Time slot does not belong to this court'
            ], 422);
        }
 
        if (!$timeSlot->is_available) {
            return response()->json([
                'success' => false,
                'message' => 'This time slot is already booked'
            ], 409);
        }
 
        if (Booking::where('time_slot_id', $timeSlot->id)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Slot already booked'
            ], 400);
        }
 
        $court = \App\Models\Court::with('sport')->findOrFail($request->court_id);
 
        $start = Carbon::parse($timeSlot->slot_date . ' ' . $timeSlot->start_time);
        $end   = Carbon::parse($timeSlot->slot_date . ' ' . $timeSlot->end_time);
 
        $hours = $start->diffInHours($end);
        $total_price = $hours * $court->price_per_hour;
 
        $booking = Booking::create([
            'user_id'      => Auth::id(),
            'court_id'     => $request->court_id,
            'time_slot_id' => $timeSlot->id,
            'start_time'   => $start,
            'end_time'     => $end,
            'total_price'  => $total_price,
            'status'       => 'pending',
        ]);
 
        $timeSlot->update(['is_available' => false]);
 
        Notification::create([
            'user_id'    => Auth::id(),
            'message'    => "Your booking has been created and is waiting for payment.",
            'sport_type' => $court->sport?->name ?? 'Sport',
            'is_read'    => false,
        ]);
 
        return response()->json([
            'success' => true,
            'message' => 'Booking created successfully',
            'data'    => $booking
        ], 201);
    }
 
    // DELETE /api/bookings/{id}
    public function destroy(int $id)
    {
        $booking = Booking::with('court.sport')->findOrFail($id);
 
        if ($booking->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
 
        TimeSlot::where('id', $booking->time_slot_id)
            ->update(['is_available' => true]);
 
        Notification::create([
            'user_id'    => Auth::id(),
            'message'    => "Your booking has been cancelled successfully. âŒ",
            'sport_type' => $booking->court->sport?->name ?? 'Sport',
            'is_read'    => false,
        ]);
 
        $booking->delete();
 
        return response()->json([
            'success' => true,
            'message' => 'Booking cancelled successfully'
        ]);
    }
}




