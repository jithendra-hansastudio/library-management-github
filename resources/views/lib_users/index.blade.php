<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Users - Management Dashboard</title>
    <link rel="stylesheet" href="{{ asset('css/bootstrap.min.css') }}">    
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">

    <!-- Dynamic System Theme Injected Here -->
    @include('partials.theme-styles')
</head>
<body>
    <br>
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
            <div>
                <h1 class="h2 mb-1">Library Users</h1>
                <p class="text-muted small mb-0">Browse and manage registered users and their system roles</p>
            </div>
            <span class="badge bg-primary fs-6">Total Users: {{ $users->count() }}</span>
        </div>

        @if($users->isEmpty())
            <div class="alert alert-info shadow-sm" role="alert">
                No users found in the system database.
            </div>
        @else
            <!-- Responsive Grid of User Cards -->
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                @foreach ($users as $libUser)
                    <div class="col">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="card-body d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title mb-0">
                                        <a href="{{ route('lib_users.show', $libUser->id) }}" class="text-decoration-none text-dark stretched-link fw-bold">
                                            {{ $libUser->user_name }}
                                        </a>
                                    </h5>
                                    <!-- Thematic role badge using standard theme colors instead of randomized/hardcoded indicators -->
                                    <span class="badge bg-secondary rounded-pill">
                                        {{ ucfirst($libUser->role) }}
                                    </span>
                                </div>
                                <p class="card-text text-muted small mb-2">
                                    <strong>Gender:</strong> {{ strtoupper($libUser->gender) }}
                                </p>
                                <p class="card-text text-muted small mt-auto">
                                    Click to view full user profile & history &rarr;
                                </p>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        @endif
    </main>
</body>
</html>