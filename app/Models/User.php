<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;
    // HasApiTokens is what Sanctum needs — it gives every user the ability
    // to have tokens generated for them when they log in

    // These fields can be mass-assigned (e.g. User::create([...]))
    // Without this list, Laravel would block all mass assignment as a security measure
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',  // we add role here so it can be set during registration
    ];

    // These fields are NEVER included in JSON responses
    // You never want to accidentally send a password hash to the mobile app
    protected $hidden = [
        'password',
        'remember_token',
    ];

    // Laravel will automatically cast these to the right PHP types
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password'          => 'hashed', // auto-hashes passwords when set
        ];
    }

    // Helper methods to easily check a user's role anywhere in the code
    // Usage: if ($user->isAdmin()) { ... }
    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }

    public function isPlayer(): bool
    {
        return $this->role === 'player';
    }

    public function isStaff(): bool
    {
        return $this->role === 'staff';
    }
}
