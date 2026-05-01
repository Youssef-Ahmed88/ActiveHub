<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            SportSeeder::class,
            CourtSeeder::class,
            UserSeeder::class,
            TimeSlotSeeder::class,
        ]);
    }
}