<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Sport extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'icon',
        'description',
    ];

    // One sport has many courts
    public function courts()
    {
        return $this->hasMany(Court::class);
    }
}