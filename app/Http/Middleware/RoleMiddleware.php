<?php

namespace App\Http\Middleware;

use App\Helpers\ApiResponse;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * The $roles parameter is how we pass which roles are allowed into this
     * middleware. For example, when we write middleware('role:admin') in a
     * route, Laravel calls this handle() method with $roles = 'admin'.
     * We can also pass multiple roles like middleware('role:admin,staff'),
     * which means "either admin OR staff can pass through."
     */
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        // First check: is the user even logged in?
        // If auth:sanctum is applied before this middleware, this will always
        // be true — but it's good defensive programming to check anyway.
        if (!$request->user()) {
            return ApiResponse::error(
                message: 'Unauthenticated',
                statusCode: 401
            );
        }

        // Second check: does the user's role match one of the allowed roles?
        // in_array() checks if the user's role exists in the $roles array.
        // For example, if $roles = ['admin', 'staff'] and $user->role = 'player',
        // this check fails and we return a 403 Forbidden.
        if (!in_array($request->user()->role, $roles)) {
            return ApiResponse::error(
                message: 'Forbidden. You do not have access to this resource.',
                statusCode: 403 // 403 = Forbidden (different from 401 Unauthorized)
                                // 401 means "I don't know who you are"
                                // 403 means "I know who you are, but you can't do this"
            );
        }

        // If both checks pass, let the request continue to the controller
        return $next($request);
    }
}