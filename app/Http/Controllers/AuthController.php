<?php

namespace App\Http\Controllers;

use App\Models\LibUser;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    // Show login form
    public function showLoginForm()
    {
        return view('auth.login');
    }

    // Process login attempt (Plain-text comparison)
    public function login(Request $request)
    {
        $request->validate([
            'user_name' => 'required|string',
            'password'  => 'required|string',
        ]);

        // Direct plain-text matching
        $user = LibUser::where('user_name', $request->user_name)
                       ->where('password', $request->password)
                       ->first();

        if ($user) {
            Auth::login($user); // Log the user into Laravel session
            $request->session()->regenerate();

            return redirect()->intended('/home');
        }

        return back()->withErrors([
            'user_name' => 'Invalid username or password.',
        ]);
    }

    // Logout
    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/login');
    }
}