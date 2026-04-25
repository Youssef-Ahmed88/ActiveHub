<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Helpers\ApiResponse;
use App\Models\Court;
use App\Services\CourtService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CourtController extends Controller
{
    public function __construct(private CourtService $courtService)
    {
    }

    /**
     * GET /api/courts
     * Public — anyone can browse courts
     */
    public function index(): JsonResponse
    {
        $courts = $this->courtService->getAll();

        return ApiResponse::success(
            message: 'Courts retrieved successfully',
            data: $courts
        );
    }

    /**
     * GET /api/courts/{id}
     * Public — get a single court with its sport
     */
    public function show(Court $court): JsonResponse
    {
        $court->load('sport');

        return ApiResponse::success(
            message: 'Court retrieved successfully',
            data: $court
        );
    }

    /**
     * POST /api/courts
     * Admin only — create a new court
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'           => 'required|string|max:255',
            'sport_id'       => 'required|exists:sports,id', // must be a valid sport
            'description'    => 'nullable|string',
            'price_per_hour' => 'required|numeric|min:0',
            'latitude'       => 'nullable|numeric',
            'longitude'      => 'nullable|numeric',
        ]);

        $court = $this->courtService->create($validated);
        $court->load('sport');

        return ApiResponse::success(
            message: 'Court created successfully',
            data: $court,
            statusCode: 201
        );
    }

    /**
     * PUT /api/courts/{id}
     * Admin only — update a court
     */
    public function update(Request $request, Court $court): JsonResponse
    {
        $validated = $request->validate([
            'name'           => 'sometimes|string|max:255',
            'sport_id'       => 'sometimes|exists:sports,id',
            'description'    => 'nullable|string',
            'price_per_hour' => 'sometimes|numeric|min:0',
            'latitude'       => 'nullable|numeric',
            'longitude'      => 'nullable|numeric',
        ]);

        $court = $this->courtService->update($court, $validated);

        return ApiResponse::success(
            message: 'Court updated successfully',
            data: $court
        );
    }

    /**
     * DELETE /api/courts/{id}
     * Admin only — delete a court
     */
    public function destroy(Court $court): JsonResponse
    {
        $this->courtService->delete($court);

        return ApiResponse::success(
            message: 'Court deleted successfully'
        );
    }
}