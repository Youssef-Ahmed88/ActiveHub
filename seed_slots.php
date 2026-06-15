<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$courts = \App\Models\Court::all();
$count = 0;

foreach ($courts as $court) {
    for ($day = 0; $day < 30; $day++) {
        $date = now()->addDays($day)->format('Y-m-d');
        for ($hour = 8; $hour <= 20; $hour++) {
            $exists = \App\Models\TimeSlot::where('court_id', $court->id)
                ->where('slot_date', $date)
                ->where('start_time', sprintf('%02d:00:00', $hour))
                ->exists();
            if (!$exists) {
                \App\Models\TimeSlot::create([
                    'court_id' => $court->id,
                    'slot_date' => $date,
                    'start_time' => sprintf('%02d:00:00', $hour),
                    'end_time' => sprintf('%02d:00:00', $hour + 1),
                    'is_available' => true,
                ]);
                $count++;
            }
        }
    }
}
echo "Done! Created $count slots.\n";
