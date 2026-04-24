<?php

use App\Helpers\ApiResponse;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->statefulApi();

        $middleware->alias([
            'role' => \App\Http\Middleware\RoleMiddleware::class,
        ]);

        // Return JSON 401 instead of redirecting to 'login' route
        $middleware->redirectGuestsTo(fn() => response()->json([
            'success' => false,
            'message' => 'Unauthenticated. Please login first.',
            'data'    => null,
        ], 401));
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (\Throwable $e, Request $request) {
            if ($request->is('api/*')) {
                if ($e instanceof \Illuminate\Validation\ValidationException) {
                    return ApiResponse::error(
                        message: 'Validation failed',
                        data: $e->errors(),
                        statusCode: 422
                    );
                }
                if ($e instanceof \Illuminate\Auth\AuthenticationException) {
                    return ApiResponse::error(
                        message: 'Unauthenticated. Please login first.',
                        statusCode: 401
                    );
                }
                if ($e instanceof \Illuminate\Auth\Access\AuthorizationException) {
                    return ApiResponse::error(
                        message: 'Forbidden. You do not have access to this resource.',
                        statusCode: 403
                    );
                }
                if ($e instanceof \Illuminate\Database\Eloquent\ModelNotFoundException) {
                    return ApiResponse::error(
                        message: 'Resource not found.',
                        statusCode: 404
                    );
                }
                if ($e instanceof \Symfony\Component\HttpKernel\Exception\NotFoundHttpException) {
                    return ApiResponse::error(
                        message: 'Route not found.',
                        statusCode: 404
                    );
                }
                return ApiResponse::error(
                    message: 'Server error. Please try again later.',
                    data: config('app.debug') ? [
                        'error' => $e->getMessage(),
                        'file'  => $e->getFile(),
                        'line'  => $e->getLine(),
                    ] : null,
                    statusCode: 500
                );
            }
        });
    })->create();