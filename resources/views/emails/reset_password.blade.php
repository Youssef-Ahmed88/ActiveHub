<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { background: white; padding: 30px; border-radius: 10px; max-width: 500px; margin: auto; }
        .code { font-size: 36px; font-weight: bold; color: #7C3AED; letter-spacing: 8px; text-align: center; margin: 20px 0; }
        .footer { color: #999; font-size: 12px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Hello, {{ $user->full_name }}! 👋</h2>
        <p>We received a request to reset your <strong>ActiveHub</strong> password.</p>
        <p>Use this code to reset your password. It expires in <strong>60 minutes</strong>.</p>
        <div class="code">{{ $code }}</div>
        <p class="footer">If you didn't request this, ignore this email.</p>
    </div>
</body>
</html>