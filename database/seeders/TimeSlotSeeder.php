<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\TimeSlot;
use App\Models\Court;

class TimeSlotSeeder extends Seeder
{
    public function run(): void
    {
        $courts = Court::all();
        $startDate = now()->addDay(); // من الغد
        $endDate = now()->addDays(30); // لمدة 30 يوماً
        
        for ($date = $startDate; $date->lte($endDate); $date->addDay()) {
            foreach ($courts as $court) {
                for ($hour = 8; $hour <= 20; $hour++) { // ساعات 8 صباحاً حتى 8 مساءً
                    TimeSlot::firstOrCreate([
                        'court_id' => $court->id,
                        'slot_date' => $date->toDateString(),
                        'start_time' => sprintf('%02d:00:00', $hour),
                        'end_time' => sprintf('%02d:00:00', $hour + 1),
                    ], [
                        'is_available' => true,
                    ]);
                }
            }
        }
    }
}