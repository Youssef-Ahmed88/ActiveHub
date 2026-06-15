<?php
return [
    'groq' => [
        'api_key' => env('GROQ_API_KEY'),
    ],
    'paymob' => [
        'api_key'        => env('PAYMOB_API_KEY'),
        'secret_key'     => env('PAYMOB_SECRET_KEY'),
        'integration_id' => env('PAYMOB_INTEGRATION_ID'),
        'iframe_id'      => env('PAYMOB_IFRAME_ID'),
        'base_url'       => env('PAYMOB_BASE_URL', 'https://accept.paymob.com'),
    ],
    'postmark' => [
        'key' => env('POSTMARK_API_KEY'),
    ],
    'resend' => [
        'key' => env('RESEND_API_KEY'),
    ],
    'ses' => [
        'key'    => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],
    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel'              => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],
];