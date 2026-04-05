<?php

namespace App\Http\Controllers\Auth;

use App\Helpers\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Services\AuthService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    // Dependency Injection — Laravel automatically creates an AuthService instance
    // and passes it here. We don't need to write "new AuthService()" anywhere.
    // Think of it like ordering room service — you just say what you want,
    // and it appears at your door.
    public function __construct(private AuthService $authService)
    {
    }

    /**
     * POST /api/auth/register
     */
    public function register(RegisterRequest $request): JsonResponse
    {
        // $request->validated() returns ONLY the fields that passed validation.
        // Even if the mobile app sends extra junk fields, they won't be here.
        $result = $this->authService->register($request->validated());

        return ApiResponse::success(
            message: 'User registered successfully',
            data: [
                'user'  => $result['user'],
                'token' => $result['token'],
            ],
            statusCode: 201 // 201 = "Created" — more accurate than 200 for new resources
        );
    }

    /**
     * POST /api/auth/login
     */
    public function login(LoginRequest $request): JsonResponse
    {
        $result = $this->authService->login($request->validated());

        if (!$result) {
            return ApiResponse::error(
                message: 'Invalid email or password',
                statusCode: 401 // 401 = "Unauthorized"
            );
        }

        return ApiResponse::success(
            message: 'Login successful',
            data: [
                'user'  => $result['user'],
                'token' => $result['token'],
            ]
        );
    }

    /**
     * POST /api/auth/logout
     * This route is protected — only logged-in users can hit it.
     */
    public function logout(Request $request): JsonResponse
    {
        $this->authService->logout($request->user());

        return ApiResponse::success(message: 'Logged out successfully');
    }
}