<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Users Directory - Library Management</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
            <div>
                <h1 class="h2 mb-1">Library Users Directory</h1>
                <p class="text-muted small mb-0">Manage registered members, librarians, and administrative users</p>
            </div>
            <span class="badge bg-primary fs-6">Total Users: {{ $users->count() }}</span>
        </div>

        @if($users->isEmpty())
            <div class="alert alert-info shadow-sm" role="alert">
                No users found in the system database.
            </div>
        @else
            <!-- Responsive Table View -->
            <div class="table-responsive shadow-sm bg-white rounded border">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" class="ps-3">ID</th>
                            <th scope="col">Full Name</th>
                            <th scope="col">Role</th>
                            <th scope="col">Transactions</th>
                            <th scope="col" class="text-end pe-3">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($users as $user)
                            <tr>
                                <td class="ps-3 fw-bold text-secondary">#{{ $user->id }}</td>
                                <td>
                                    <span class="fw-semibold text-dark">{{ $user->user_name }}</span>
                                </td>
                                <td>
                                    @php
                                        $roleBadges = [
                                            'admin' => 'bg-danger',
                                            'librarian' => 'bg-warning text-dark',
                                            'member' => 'bg-info text-dark',
                                            'visitor' => 'bg-secondary'
                                        ];
                                        $badgeClass = $roleBadges[strtolower($user->role)] ?? 'bg-primary';
                                    @endphp
                                    <span class="badge {{ $badgeClass }}">{{ ucfirst($user->role) }}</span>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">
                                        {{ $user->transactions_count }} {{ Str::plural('Record', $user->transactions_count) }}
                                    </span>
                                </td>
                                <td class="text-end pe-3">
                                    <a href="{{ route('lib_users.show', $user->id) }}" class="btn btn-sm btn-outline-primary">
                                        View Profile &rarr;
                                    </a>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        @endif
    </main>

</body>
</html>