<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Helpers\ApiResponse;
use App\Models\Sport;
use Illuminate\Http\Request;

class SportController extends Controller
{
public function index()
{
    return ApiResponse::success('Sports retrieved successfully', Sport::all());
}

    public function show(Sport $sport)
    {
        return ApiResponse::success($sport, 'Sport retrieved successfully');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'        => 'required|string|unique:sports,name',
            'icon'        => 'nullable|string',
            'description' => 'nullable|string',
        ]);

        $sport = Sport::create($validated);
        return ApiResponse::success($sport, 'Sport created successfully', 201);
    }

    public function update(Request $request, Sport $sport)
    {
        $validated = $request->validate([
            'name'        => 'sometimes|string|unique:sports,name,'.$sport->id,
            'icon'        => 'nullable|string',
            'description' => 'nullable|string',
        ]);

        $sport->update($validated);
        return ApiResponse::success($sport, 'Sport updated successfully');
    }

    public function destroy(Sport $sport)
    {
        $sport->delete();
        return ApiResponse::success('Sport deleted successfully', null);
    }
}
