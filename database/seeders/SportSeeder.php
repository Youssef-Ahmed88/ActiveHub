<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Sport;

class SportSeeder extends Seeder
{
    public function run(): void
    {
        $sports = [
            ['name' => 'Football',   'icon' => '⚽'],
            ['name' => 'Padel',      'icon' => '🎾'],
            ['name' => 'Basketball', 'icon' => '🏀'],
        ];

        foreach ($sports as $sport) {
            Sport::create($sport);
        }
    }
}