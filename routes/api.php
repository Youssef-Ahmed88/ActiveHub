<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Auth\PasswordResetController;
use App\Http\Controllers\Api\SportController;
use App\Http\Controllers\Api\CourtController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ChatbotController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\TimeSlotController;
 
Route::get('/ping', function () {
    return response()->json([
        'success' => true,
        'message' => 'ActiveHub API is alive 🟢',
    ]);
});
 
Route::prefix('auth')->group(function () {
    Route::post('/register',        [AuthController::class, 'register']);
    Route::post('/login',           [AuthController::class, 'login']);
    Route::post('/forgot-password', [PasswordResetController::class, 'sendResetCode']);
    Route::post('/reset-password',  [PasswordResetController::class, 'resetPassword']);
});
 
Route::get('/sports',            [SportController::class, 'index']);
Route::get('/sports/{sport}',    [SportController::class, 'show']);
Route::get('/courts',            [CourtController::class, 'index']);
Route::get('/courts/{court}',    [CourtController::class, 'show']);
Route::get('/courts/{id}/slots', [TimeSlotController::class, 'available']);
Route::get('/reviews',           [ReviewController::class, 'index']);
Route::get('/reviews/{review}',  [ReviewController::class, 'show']);
 
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', fn(Request $request) => $request->user());
    Route::post('/auth/logout', [AuthController::class, 'logout']);
 
    Route::post('/bookings',        [BookingController::class, 'store']);
    Route::get('/my-bookings',      [BookingController::class, 'myBookings']);
    Route::delete('/bookings/{id}', [BookingController::class, 'destroy']);
 
    Route::post('/payments', [PaymentController::class, 'store']);
 
    Route::post('/reviews',            [ReviewController::class, 'store']);
    Route::delete('/reviews/{review}', [ReviewController::class, 'destroy']);
 
    Route::get('/notifications',                       [NotificationController::class, 'index']);
    Route::patch('/notifications/{notification}/read', [NotificationController::class, 'markAsRead']);
    Route::delete('/notifications/{notification}',     [NotificationController::class, 'destroy']);
 
    Route::post('/chatbot', [ChatbotController::class, 'chat']);
 
    Route::middleware('role:owner')->group(function () {
        Route::get('/owner/courts',   [CourtController::class, 'ownerIndex']);
        Route::get('/owner/bookings', [BookingController::class, 'ownerBookings']);
    });
 
    Route::middleware('role:admin')->group(function () {
        Route::post('/sports',            [SportController::class, 'store']);
        Route::put('/sports/{sport}',     [SportController::class, 'update']);
        Route::delete('/sports/{sport}',  [SportController::class, 'destroy']);
        Route::post('/courts',            [CourtController::class, 'store']);
        Route::put('/courts/{court}',     [CourtController::class, 'update']);
        Route::delete('/courts/{court}',  [CourtController::class, 'destroy']);
        Route::get('/payments',           [PaymentController::class, 'index']);
        Route::get('/payments/{payment}', [PaymentController::class, 'show']);
    });
});