<?php

namespace App\Helpers;

use Illuminate\Http\JsonResponse;

class ApiResponse
{
    /**
     * Send a successful JSON response.
     * 
     * Think of this as the "green light" response — everything went well,
     * here's the data you asked for.
     */
    public static function success(
        string $message = 'Success',
        mixed $data = null,
        int $statusCode = 200
    ): JsonResponse {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data'    => $data,
        ], $statusCode);
    }

    /**
     * Send an error JSON response.
     * 
     * Think of this as the "red light" response — something went wrong,
     * here's what happened and why.
     */
    public static function error(
        string $message = 'Something went wrong',
        mixed $data = null,
        int $statusCode = 422
    ): JsonResponse {
        return response()->json([
            'success' => false,
            'message' => $message,
            'data'    => $data,
        ], $statusCode);
    }
}