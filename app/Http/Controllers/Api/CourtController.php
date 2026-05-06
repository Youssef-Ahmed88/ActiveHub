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
 * GET /api/owner/courts
 * Owner only — get their own courts
 */
public function ownerIndex(Request $request): JsonResponse
{
    $courts = $this->courtService->getByOwner($request->user()->id);
    
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
  /**
 * POST /api/courts
 * Only admin can create a court. Can also create a new owner account.
 */
public function store(Request $request): JsonResponse
{
    // 1. Check if logged in user is admin
    if (!$request->user()->isAdmin()) {
        return response()->json(['error' => 'Not allowed'], 403);
    }

    // 2. Validation rules
    $validated = $request->validate([
        'name'           => 'required|string|max:255',          // Court name
        'sport_id'       => 'required|exists:sports,id',       // Which sport
        'description'    => 'nullable|string',                 // Optional description
        'price_per_hour' => 'required|numeric|min:0',          // Price per hour
        'latitude'       => 'nullable|numeric',                // GPS latitude
        'longitude'      => 'nullable|numeric',                // GPS longitude
        
        // Two options:
        // Option 1: Use an existing owner (by ID)
        'owner_id'       => 'nullable|exists:users,id',
        
        // Option 2: Create a new owner (email, name, password)
        'owner_email'    => 'nullable|email|unique:users,email',
        'owner_name'     => 'required_with:owner_email|string|max:255',
        'owner_password' => 'required_with:owner_email|string|min:6',
    ]);

    // 3. Start with owner_id if provided
    $ownerId = $validated['owner_id'] ?? null;

    // 4. If no owner_id but we have owner_email → create new owner
    if (!$ownerId && isset($validated['owner_email'])) {
        $owner = \App\Models\User::create([
            'full_name' => $validated['owner_name'],
            'email'     => $validated['owner_email'],
            'password'  => bcrypt($validated['owner_password']),
            'role'      => 'owner',
        ]);
        $ownerId = $owner->id;
    }

    // 5. Make sure we have an owner_id (otherwise error)
    if (!$ownerId) {
        return response()->json([
            'error' => 'You must provide either owner_id or owner_email+owner_name+owner_password'
        ], 422);
    }

    // 6. Add owner_id to court data
    $courtData = array_merge($validated, ['owner_id' => $ownerId]);

    // 7. Create court using the service
    $court = $this->courtService->create($courtData);

    // 8. Return success response
    return ApiResponse::success(
        message: isset($owner) ? 'Court created and owner account created' : 'Court created successfully',
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
        'owner_id'       => 'sometimes|exists:users,id', // ✅ ضيف السطر ده
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


