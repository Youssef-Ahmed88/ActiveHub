<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Helpers\ApiResponse;
use App\Models\Court;
use App\Models\User;
use App\Services\CourtService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CourtController extends Controller
{
    public function __construct(private CourtService $courtService)
    {
    }

    public function index(): JsonResponse
    {
        $courts = $this->courtService->getAll();
        return ApiResponse::success(message: 'Courts retrieved successfully', data: $courts);
    }

    public function ownerIndex(Request $request): JsonResponse
    {
        $courts = $this->courtService->getByOwner($request->user()->id);
        return ApiResponse::success(message: 'Courts retrieved successfully', data: $courts);
    }

    public function show(Court $court): JsonResponse
    {
        $court->load('sport');
        return ApiResponse::success(message: 'Court retrieved successfully', data: $court);
    }

    public function store(Request $request): JsonResponse
    {
        if (!$request->user()->isAdmin()) {
            return response()->json(['error' => 'Not allowed'], 403);
        }

        $validated = $request->validate([
            'name'           => 'required|string|max:255',
            'sport_id'       => 'required|exists:sports,id',
            'description'    => 'nullable|string',
            'price_per_hour' => 'required|numeric|min:0',
            'latitude'       => 'nullable|numeric',
            'longitude'      => 'nullable|numeric',
            'owner_id'       => 'nullable|exists:users,id',
            'owner_email'    => 'nullable|email|unique:users,email',
            'owner_name'     => 'required_with:owner_email|string|max:255',
            'owner_password' => 'required_with:owner_email|string|min:6',
        ]);

        $ownerId = $validated['owner_id'] ?? null;

        if (!$ownerId && isset($validated['owner_email'])) {
            $owner = User::create([
                'full_name' => $validated['owner_name'],
                'email'     => $validated['owner_email'],
                'password'  => bcrypt($validated['owner_password']),
                'role'      => 'owner',
            ]);
            $ownerId = $owner->id;
        }

        if (!$ownerId) {
            return response()->json(['error' => 'You must provide either owner_id or owner_email+owner_name+owner_password'], 422);
        }

        $courtData = array_merge($validated, ['owner_id' => $ownerId]);
        $court = $this->courtService->create($courtData);

        return ApiResponse::success(
            message: isset($owner) ? 'Court created and owner account created' : 'Court created successfully',
            data: $court,
            statusCode: 201
        );
    }

    public function update(Request $request, Court $court): JsonResponse
    {
        $validated = $request->validate([
            'name'           => 'sometimes|string|max:255',
            'sport_id'       => 'sometimes|exists:sports,id',
            'owner_id'       => 'nullable|exists:users,id',
            'description'    => 'nullable|string',
            'price_per_hour' => 'sometimes|numeric|min:0',
            'is_available'   => 'sometimes|boolean',
            'latitude'       => 'nullable|numeric',
            'longitude'      => 'nullable|numeric',
            'owner_email'    => 'nullable|email|unique:users,email',
            'owner_name'     => 'required_with:owner_email|string|max:255',
            'owner_password' => 'required_with:owner_email|string|min:6',
        ]);

        if (!$court->owner_id && isset($validated['owner_email'])) {
            $owner = User::create([
                'full_name' => $validated['owner_name'],
                'email'     => $validated['owner_email'],
                'password'  => bcrypt($validated['owner_password']),
                'role'      => 'owner',
            ]);
            $validated['owner_id'] = $owner->id;
        }

        $court = $this->courtService->update($court, $validated);

        return ApiResponse::success(message: 'Court updated successfully', data: $court);
    }

    public function destroy(Court $court): JsonResponse
    {
        $this->courtService->delete($court);
        return ApiResponse::success(message: 'Court deleted successfully');
    }
}