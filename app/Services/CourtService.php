<?php

namespace App\Services;

use App\Models\Court;

class CourtService
{
    // Get all courts with their sport info
    public function getAll()
    {
        return Court::with('sport')->get();
    }

    // Get one court with sport info
    public function getById(int $id)
    {
        return Court::with('sport')->findOrFail($id);
    }

    // Create a new court
    public function create(array $data): Court
    {
        return Court::create($data);
    }

    // Update a court
    public function update(Court $court, array $data): Court
    {
        $court->update($data);
        return $court->fresh('sport'); // reload with sport relation
    }

    // Delete a court
    public function delete(Court $court): void
    {
        $court->delete();
    }

    // Get all courts for a specific sport
    public function getBySport(int $sportId)
    {
        return Court::with('sport')
            ->where('sport_id', $sportId)
            ->get();
    }
}