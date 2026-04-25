<?php

use App\Helpers\ApiResponse;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CourtController;
use App\Http\Controllers\SportController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Health check
Route::get('/ping', function () {
    return response()->json([
        'success' => true,
        'message' => 'ActiveHub API is alive 🟢',
    ]);
});

// ─── Auth Routes ──────────────────────────────────────────
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);
    Route::post('/logout',   [AuthController::class, 'logout'])->middleware('auth:sanctum');
});

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// ─── Sports Routes ────────────────────────────────────────
Route::get('/sports',         [SportController::class, 'index']);
Route::get('/sports/{sport}', [SportController::class, 'show']);

Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/sports',           [SportController::class, 'store']);
    Route::put('/sports/{sport}',    [SportController::class, 'update']);
    Route::delete('/sports/{sport}', [SportController::class, 'destroy']);
});

// ─── Courts Routes ────────────────────────────────────────
// Public
Route::get('/courts',          [CourtController::class, 'index']);
Route::get('/courts/{court}',  [CourtController::class, 'show']);

// Admin only
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/courts',           [CourtController::class, 'store']);
    Route::put('/courts/{court}',    [CourtController::class, 'update']);
    Route::delete('/courts/{court}', [CourtController::class, 'destroy']);
});