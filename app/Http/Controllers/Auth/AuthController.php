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
    try {
        $result = $this->authService->register($request->validated());

        return ApiResponse::success(
            message: 'User registered successfully',
            data: [
                'user'  => $result['user'],
                'token' => $result['token'],
            ],
            statusCode: 201
        );
    } catch (\Exception $e) {
        return ApiResponse::error(
            message: 'Registration failed. Please try again.',
            statusCode: 500
        );
    }
}

    /**
     * POST /api/auth/login
     */
    public function login(LoginRequest $request): JsonResponse
{
    try {
        $result = $this->authService->login($request->validated());

        if (!$result) {
            return ApiResponse::error(
                message: 'Invalid email or password',
                statusCode: 401
            );
        }

        return ApiResponse::success(
            message: 'Login successful',
            data: [
                'user'  => $result['user'],
                'token' => $result['token'],
            ]
        );
    } catch (\Exception $e) {
        return ApiResponse::error(
            message: 'Login failed. Please try again.',
            statusCode: 500
        );
    }
}

    /**
     * POST /api/auth/logout
     * This route is protected — only logged-in users can hit it.
     */
    public function logout(Request $request): JsonResponse
{
    try {
        $this->authService->logout($request->user());
        return ApiResponse::success(message: 'Logged out successfully');
    } catch (\Exception $e) {
        return ApiResponse::error(
            message: 'Logout failed. Please try again.',
            statusCode: 500
        );
    }
}
}
