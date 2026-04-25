<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Court extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'sport_id',
        'description',
        'price_per_hour',
        'latitude',
        'longitude',
    ];

    protected function casts(): array
    {
        return [
            'price_per_hour' => 'decimal:2',
            'latitude'       => 'decimal:7',
            'longitude'      => 'decimal:7',
        ];
    }

    // A court belongs to one sport
    // e.g. Court "Pitch A" belongs to Football
    public function sport()
    {
        return $this->belongsTo(Sport::class);
    }

    // A court has many time slots
    public function timeSlots()
    {
        return $this->hasMany(TimeSlot::class);
    }

    // A court has many bookings
    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }
}