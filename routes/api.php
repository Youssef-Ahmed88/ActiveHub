<?php

use App\Helpers\ApiResponse;
use App\Http\Controllers\Auth\AuthController;
use Illuminate\Support\Facades\Route;


// Health check
Route::get('/ping', function () {
    return response()->json([
        'success' => true,
        'message' => 'ActiveHub API is alive 🟢',
    ]);
});

// Auth routes — grouped under /api/auth/
// No middleware here because these are public endpoints (no login required)
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);

    // 'auth:sanctum' middleware protects this route — it checks that the request
    // carries a valid Sanctum token. If not, Laravel automatically returns a 401.
    Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
});

// These routes require login AND a specific role
// Think of them as different rooms in a building, each with its own keycard requirement

Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::get('/admin/dashboard', function () {
        return ApiResponse::success(
            message: 'Welcome to the admin dashboard',
            data: ['role' => auth()->user()->role]
        );
    });
});

Route::middleware(['auth:sanctum', 'role:player'])->group(function () {
    Route::get('/player/home', function () {
        return ApiResponse::success(
            message: 'Welcome player!',
            data: ['role' => auth()->user()->role]
        );
    });
});

Route::middleware(['auth:sanctum', 'role:admin,staff'])->group(function () {
    Route::get('/manage/bookings', function () {
        return ApiResponse::success(
            message: 'Booking management area',
            data: ['role' => auth()->user()->role]
        );
    });
});