<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Court;
use App\Models\TimeSlot;

class SeedSlots extends Command
{
    protected $signature = 'slots:seed';
    protected $description = 'Seed time slots for all courts';

    public function handle()
    {
        $courts = Court::all();
        $count = 0;

        foreach ($courts as $court) {
            for ($day = 0; $day < 30; $day++) {
                $date = now()->addDays($day)->format('Y-m-d');
                for ($hour = 8; $hour <= 20; $hour++) {
                    $exists = TimeSlot::where('court_id', $court->id)
                        ->where('slot_date', $date)
                        ->where('start_time', sprintf('%02d:00:00', $hour))
                        ->exists();
                    if (!$exists) {
                        TimeSlot::create([
                            'court_id'   => $court->id,
                            'slot_date'  => $date,
                            'start_time' => sprintf('%02d:00:00', $hour),
                            'end_time'   => sprintf('%02d:00:00', $hour + 1),
                            'is_available' => true,
                        ]);
                        $count++;
                    }
                }
            }
        }

        $this->info("Done! Created $count slots.");
    }
}