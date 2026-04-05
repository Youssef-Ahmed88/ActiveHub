<?php

namespace App\Http\Controllers;

use App\Helpers\ApiResponse;

abstract class Controller
{
    // By importing ApiResponse here in the base controller,
    // every controller that extends this one automatically has access to it.
    // It's like giving every employee in a company the same toolkit on day one.
    use \Illuminate\Foundation\Auth\Access\AuthorizesRequests;
}