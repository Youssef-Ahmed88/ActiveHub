<?php

namespace App\Http\Controllers\Auth;

use App\Helpers\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use App\Models\User;
use Carbon\Carbon;

class PasswordResetController extends Controller
{
    public function sendResetCode(Request $request): JsonResponse
    {
        $request->validate(['email' => 'required|email']);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return ApiResponse::error(
                message: 'No account found with this email.',
                statusCode: 404
            );
        }

        // كود 6 أرقام
        $code = rand(100000, 999999);

        DB::table('password_reset_tokens')->updateOrInsert(
            ['email' => $request->email],
            [
                'token'      => Hash::make($code),
                'created_at' => Carbon::now(),
            ]
        );

        Mail::send('emails.reset_password', ['code' => $code, 'user' => $user], function ($message) use ($user) {
            $message->to($user->email)
                    ->subject('Reset Your Password - ActiveHub');
        });

        return ApiResponse::success(message: 'Reset code sent to your email.');
    }

    public function resetPassword(Request $request): JsonResponse
    {
        $request->validate([
            'email'                 => 'required|email',
            'code'                  => 'required|string',
            'password'              => 'required|min:8|confirmed',
        ]);

        $record = DB::table('password_reset_tokens')
            ->where('email', $request->email)
            ->first();

        if (!$record || !Hash::check($request->code, $record->token)) {
            return ApiResponse::error(
                message: 'Invalid or expired code.',
                statusCode: 400
            );
        }

        if (Carbon::parse($record->created_at)->addMinutes(60)->isPast()) {
            return ApiResponse::error(
                message: 'Code has expired. Please request a new one.',
                statusCode: 400
            );
        }

        User::where('email', $request->email)->update([
            'password' => Hash::make($request->password),
        ]);

        DB::table('password_reset_tokens')->where('email', $request->email)->delete();

        return ApiResponse::success(message: 'Password reset successfully.');
    }
}