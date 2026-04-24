<?php

use App\Helpers\ApiResponse;
use App\Http\Controllers\Auth\AuthController;
use Illuminate\Support\Facades\Route;

// Health check
Route::get('/ping', function () {
    return response()->json(['message' => 'ok']);
});

// Auth routes — public, no login required
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);
    Route::post('/logout',   [AuthController::class, 'logout'])->middleware('auth:sanctum');
});

// Test routes for role middleware
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