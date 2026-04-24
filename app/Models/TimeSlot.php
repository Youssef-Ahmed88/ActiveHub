<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TimeSlot extends Model
{
    protected $fillable = [
        'court_id',
        'slot_date',
        'start_time',
        'end_time',
        'is_available'
    ];

    protected $casts = [
        'is_available' => 'boolean',
    ];

    public function court()
    {
        return $this->belongsTo(Court::class);
    }
}