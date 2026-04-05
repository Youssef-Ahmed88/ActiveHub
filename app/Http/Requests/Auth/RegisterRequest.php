<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
    // authorize() controls who can make this request.
    // Returning true means anyone can hit this endpoint — which makes sense
    // for registration since the user doesn't have an account yet.
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            // 'required' means the field must exist and not be empty
            // 'string' means it must be text
            // 'max:255' prevents someone from sending a 10,000 character name
            'name'     => ['required', 'string', 'max:255'],

            // 'email' validates the format (must contain @ and a domain)
            // 'unique:users' checks the database — no two users can share an email
            'email'    => ['required', 'string', 'email', 'max:255', 'unique:users'],

            // 'min:8' enforces a minimum password length
            // 'confirmed' means the request must also contain 'password_confirmation'
            // that matches — this is a common registration pattern
            'password' => ['required', 'string', 'min:8', 'confirmed'],

            // role is optional — if not provided, the User model default ('player') is used
            // 'in:admin,player,staff' means only these three values are accepted
            'role'     => ['sometimes', 'string', 'in:admin,player,staff'],
        ];
    }
}
