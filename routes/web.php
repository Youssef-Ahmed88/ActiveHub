<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/reset-password', function (Request $request) {
    $token = $request->query('token');
    $email = $request->query('email');

    return response("
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset='utf-8'>
            <title>Opening ActiveHub...</title>
        </head>
        <body>
            <script>
                window.location = 'activehub://reset-password?token={$token}&email={$email}';
                setTimeout(function() {
                    document.body.innerHTML = '<p>If the app did not open, make sure ActiveHub is installed.</p>';
                }, 2000);
            </script>
        </body>
        </html>
    ")->header('Content-Type', 'text/html');
});