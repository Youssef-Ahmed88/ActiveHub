<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Court extends Model
{
    protected $fillable = [
        'name',
        'sport_id',
        'price_per_hour',
        'latitude',
        'longitude'
    ];

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function timeSlots()
    {
        return $this->hasMany(TimeSlot::class);
    }
}