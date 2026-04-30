<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\SportController;
use App\Http\Controllers\Api\CourtController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\NotificationController;

/*
|--------------------------------------------------------------------------
| Health Check
|--------------------------------------------------------------------------
*/
Route::get('/ping', function () {
    return response()->json([
        'success' => true,
        'message' => 'ActiveHub API is alive 🟢',
    ]);
});

/*
|--------------------------------------------------------------------------
| Public Routes (No Auth)
|--------------------------------------------------------------------------
*/
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);
});

Route::get('/sports',         [SportController::class, 'index']);
Route::get('/sports/{sport}', [SportController::class, 'show']);

Route::get('/courts',         [CourtController::class, 'index']);
Route::get('/courts/{court}', [CourtController::class, 'show']);

Route::get('/reviews',            [ReviewController::class, 'index']);
Route::get('/reviews/{review}',   [ReviewController::class, 'show']);

/*
|--------------------------------------------------------------------------
| Protected Routes (Auth Required)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user', fn(Request $request) => $request->user());
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    // Reviews
    Route::post('/reviews',               [ReviewController::class, 'store']);
    Route::delete('/reviews/{review}',    [ReviewController::class, 'destroy']);

    // Notifications
    Route::get('/notifications',                       [NotificationController::class, 'index']);
    Route::patch('/notifications/{notification}/read', [NotificationController::class, 'markAsRead']);
    Route::delete('/notifications/{notification}',     [NotificationController::class, 'destroy']);

    // Admin only
    Route::middleware('role:admin')->group(function () {
        Route::post('/sports',           [SportController::class, 'store']);
        Route::put('/sports/{sport}',    [SportController::class, 'update']);
        Route::delete('/sports/{sport}', [SportController::class, 'destroy']);

        Route::post('/courts',           [CourtController::class, 'store']);
        Route::put('/courts/{court}',    [CourtController::class, 'update']);
        Route::delete('/courts/{court}', [CourtController::class, 'destroy']);

        Route::get('/payments',              [PaymentController::class, 'index']);
        Route::get('/payments/{payment}',    [PaymentController::class, 'show']);
        Route::post('/payments',             [PaymentController::class, 'store']);
    });
});