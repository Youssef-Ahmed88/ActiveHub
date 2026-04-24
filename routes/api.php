<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Controllers
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\TimeSlotController;

/*
|--------------------------------------------------------------------------
| Public Routes (No Auth)
|--------------------------------------------------------------------------
*/

// Auth
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Time Slots (display available slots for a court)
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
    Route::post('/logout', [AuthController::class, 'logout']);

    /*
    |--------------------------------------------------------------------------
    | Booking Routes
    |--------------------------------------------------------------------------
    */

    // Create Booking
    Route::post('/bookings', [BookingController::class, 'store']);

    // Get My Bookings
    Route::get('/my-bookings', [BookingController::class, 'myBookings']);

    // Cancel Booking
    Route::delete('/bookings/{id}', [BookingController::class, 'destroy']);

});