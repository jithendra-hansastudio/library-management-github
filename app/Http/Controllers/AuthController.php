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
     $credentials = $request->validate([
        'user_name' => 'required|string',
        'password'  => 'required|string',
    ]);

    // Auth::attempt automatically checks the hash and logs the user in if valid
    if (Auth::attempt($credentials)) {
        $request->session()->regenerate();

        return redirect()->intended('/home');
    }

    return back()->withErrors([
        'user_name' => 'Invalid username or password.',
    ])->onlyInput('user_name');
}


public function apiLogin(Request $request)
{
    $request->validate([
        'user_name' => 'required|string',
        'password'  => 'required|string',
    ]);

    $user = LibUser::where('user_name', $request->user_name)->first();

    if (! $user || ! \Illuminate\Support\Facades\Hash::check($request->password, $user->password)) {
        return response()->json([
            'message' => 'Invalid credentials.'
        ], 401);
    }

    // Revoke old tokens if necessary, then create a new Sanctum token
    $token = $user->createToken('flutter-mobile-app')->plainTextToken;

    return response()->json([
        'message' => 'Login successful',
        'token'   => $token,
        'user'    => $user,
    ], 200);
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