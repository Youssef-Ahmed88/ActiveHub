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
        return ApiResponse::success(
            message: 'Sports retrieved successfully',
            data: Sport::all(),
        );
    }

    public function show(Sport $sport)
    {
        return ApiResponse::success(
            message: 'Sport retrieved successfully',
            data: $sport,
        );
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'        => 'required|string|unique:sports,name',
            'icon'        => 'nullable|string',
            'description' => 'nullable|string',
        ]);

        $sport = Sport::create($validated);
        return ApiResponse::success(
            message: 'Sport created successfully',
            data: $sport,
            statusCode: 201,
        );
    }

    public function update(Request $request, Sport $sport)
    {
        $validated = $request->validate([
            'name'        => 'sometimes|string|unique:sports,name,'.$sport->id,
            'icon'        => 'nullable|string',
            'description' => 'nullable|string',
        ]);

        $sport->update($validated);
        return ApiResponse::success(
            message: 'Sport updated successfully',
            data: $sport,
        );
    }

    public function destroy(Sport $sport)
    {
        $sport->delete();
        return ApiResponse::success(
            message: 'Sport deleted successfully',
            data: null,
        );
    }
}