<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        if (!auth()->check()) {
            return redirect('/login');
        }

        $user = auth()->user();

        // Check if user's role matches any of the allowed roles
        if (!in_array($user->role, $roles)) {
            abort(403, 'Unable to access.');
        }

        return $next($request);
    }
}