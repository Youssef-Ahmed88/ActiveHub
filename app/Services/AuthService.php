<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Auth;

class AuthService
{
    /**
     * Handle the registration logic.
     * 
     * The controller will call this method and pass in the validated data.
     * We create the user, generate a token, and return both.
     * Returning an array here keeps the controller clean — it doesn't need
     * to know HOW registration works, just that it does.
     */
    public function register(array $data): array
    {
        $user = User::create([
            'name'     => $data['name'],
            'email'    => $data['email'],
            'password' => $data['password'], // remember: the User model auto-hashes this
            'role'     => $data['role'] ?? 'player', // default to 'player' if not provided
        ]);

        // createToken() is provided by Sanctum's HasApiTokens trait
        // 'auth_token' is just a label for this token — useful if a user has multiple tokens
        // (e.g., logged in on phone AND tablet)
        $token = $user->createToken('auth_token')->plainTextToken;

        return [
            'user'  => $user,
            'token' => $token,
        ];
    }

    /**
     * Handle the login logic.
     * 
     * Auth::attempt() checks if the email and password match a user in the database.
     * It does the password hash comparison for us — we never compare passwords manually.
     */
    public function login(array $credentials): array|false
    {
        if (!Auth::attempt($credentials)) {
            // Returning false signals to the controller that login failed
            return false;
        }

        /** @var \App\Models\User $user */
        $user = Auth::user();

        // Delete all previous tokens for this user before creating a new one.
        // This ensures only one active session at a time — good for mobile apps.
        $user->tokens()->delete();

        $token = $user->createToken('auth_token')->plainTextToken;

        return [
            'user'  => $user,
            'token' => $token,
        ];
    }

    /**
     * Handle logout — simply delete the current token.
     * After this, the token the mobile app holds becomes invalid.
     */
    public function logout(User $user): void
    {
        // currentAccessToken() refers to the specific token used in this request
        $user->currentAccessToken()->delete();
    }
}