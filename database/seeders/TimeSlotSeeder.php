<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\TimeSlot;

class TimeSlotSeeder extends Seeder
{
    public function run(): void
    {
        $courts = [1, 2, 3, 4, 5, 6];
        $times  = [
            ['start' => '08:00:00', 'end' => '09:00:00'],
            ['start' => '09:00:00', 'end' => '10:00:00'],
            ['start' => '10:00:00', 'end' => '11:00:00'],
            ['start' => '11:00:00', 'end' => '12:00:00'],
            ['start' => '12:00:00', 'end' => '13:00:00'],
            ['start' => '13:00:00', 'end' => '14:00:00'],
            ['start' => '14:00:00', 'end' => '15:00:00'],
            ['start' => '15:00:00', 'end' => '16:00:00'],
            ['start' => '16:00:00', 'end' => '17:00:00'],
            ['start' => '17:00:00', 'end' => '18:00:00'],
        ];

        $date = '2026-05-01';

        foreach ($courts as $court_id) {
            foreach ($times as $time) {
                TimeSlot::create([
                    'court_id'     => $court_id,
                    'slot_date'    => $date,
                    'start_time'   => $time['start'],
                    'end_time'     => $time['end'],
                    'is_available' => true,
                ]);
            }
        }
    }
}