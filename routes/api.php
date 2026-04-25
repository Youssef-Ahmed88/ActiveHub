<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Controllers
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\SportController;
use App\Http\Controllers\Api\CourtController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\TimeSlotController;

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

// Auth
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);
});

// Sports
Route::get('/sports',         [SportController::class, 'index']);
Route::get('/sports/{sport}', [SportController::class, 'show']);

// Courts
Route::get('/courts',         [CourtController::class, 'index']);
Route::get('/courts/{court}', [CourtController::class, 'show']);

// Time Slots
Route::get('/courts/{id}/slots', [TimeSlotController::class, 'available']);

/*
|--------------------------------------------------------------------------
| Protected Routes (Auth Required)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {

    // Get logged user
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Logout
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    // Sports (Admin only)
    Route::middleware('role:admin')->group(function () {
        Route::post('/sports',           [SportController::class, 'store']);
        Route::put('/sports/{sport}',    [SportController::class, 'update']);
        Route::delete('/sports/{sport}', [SportController::class, 'destroy']);

        // Courts (Admin only)
        Route::post('/courts',           [CourtController::class, 'store']);
        Route::put('/courts/{court}',    [CourtController::class, 'update']);
        Route::delete('/courts/{court}', [CourtController::class, 'destroy']);
    });

    // Bookings
    Route::post('/bookings',         [BookingController::class, 'store']);
    Route::get('/my-bookings',       [BookingController::class, 'myBookings']);
    Route::delete('/bookings/{id}',  [BookingController::class, 'destroy']);
});