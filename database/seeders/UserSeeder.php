<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // Admin
User::create([
    'full_name' => 'Admin ActiveHub',
    'email'     => 'admin@activehub.com',
    'password'  => Hash::make('password123'),
    'role'      => 'admin',
]);

User::create([
    'full_name' => 'Youssef Ahmed',
    'email'     => 'youssef@activehub.com',
    'password'  => Hash::make('password123'),
    'role'      => 'user',
]);

User::create([
    'full_name' => 'Ahmed Ali',
    'email'     => 'ahmed@activehub.com',
    'password'  => Hash::make('password123'),
    'role'      => 'user',
]);
User::create([
    'full_name' => 'Owner User',
    'email' => 'owner@example.com',
    'password' => bcrypt('123456'),
    'role' => 'owner'
]);
    }
}