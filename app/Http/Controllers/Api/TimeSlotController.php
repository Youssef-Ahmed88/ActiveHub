<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TimeSlot;
use Illuminate\Http\Request;

class TimeSlotController extends Controller
{
    // GET /api/courts/{id}/slots
public function available($courtId, Request $request)
{
    $date = $request->query('date'); // مثلاً '2026-05-07'
    $query = TimeSlot::where('court_id', $courtId);
    if ($date) {
        $query->where('slot_date', $date);
    }
    $slots = $query->get();
    return response()->json($slots);
}

    // (اختياري) create slots
    public function store(Request $request)
    {
        $request->validate([
            'court_id' => 'required|exists:courts,id',
            'slot_date' => 'required|date',
            'start_time' => 'required',
            'end_time' => 'required',
        ]);

        $slot = TimeSlot::create([
            'court_id' => $request->court_id,
            'slot_date' => $request->slot_date,
            'start_time' => $request->start_time,
            'end_time' => $request->end_time,
            'is_available' => true
        ]);

        return response()->json($slot, 201);
    }
}