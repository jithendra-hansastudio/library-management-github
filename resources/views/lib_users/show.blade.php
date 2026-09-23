<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $user->user_name }} - User Profile</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Back Navigation Button -->
        <a href="{{ route('lib_users.index') }}" class="btn btn-outline-secondary mb-4">&larr; Back to Users List</a>

        <!-- Profile Header Card -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h1 class="h3 mb-0 text-primary">{{ $user->user_name }}</h1>
                @php
                    $roleBadges = [
                        'admin' => 'bg-danger',
                        'librarian' => 'bg-warning text-dark',
                        'member' => 'bg-info text-dark',
                        'visitor' => 'bg-secondary'
                    ];
                    $badgeClass = $roleBadges[strtolower($user->role)] ?? 'bg-primary';
                @endphp
                <span class="badge {{ $badgeClass }} fs-6">{{ ucfirst($user->role) }}</span>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="fw-semibold">Gender</span>
                                <span>{{ strtoupper($user->gender) }}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="fw-semibold">Date of Birth</span>
                                <span>{{ $user->date_of_birth }}</span>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="fw-semibold">Address</span>
                                <span>{{ $user->address }}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span class="fw-semibold">Member Since</span>
                                <span class="text-muted">{{ $user->created_at->format('M d, Y') }}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Borrowing History (Transactions) -->
        <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
            <h2 class="h4 mb-0">Borrowing History</h2>
        </div>

        @if($user->transactions->isEmpty())
            <div class="alert alert-info shadow-sm" role="alert">
                No transaction history found for this user.
            </div>
        @else
            <div class="table-responsive shadow-sm bg-white rounded border mb-4">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" class="ps-3">Book</th>
                            <th scope="col">Status</th>
                            <th scope="col">Issue Date</th>
                            <th scope="col">Due Date</th>
                            <th scope="col">Returned On</th>
                            <th scope="col" class="text-end pe-3">Fine Paid</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($user->transactions as $transaction)
                            <tr>
                                <td class="ps-3 fw-bold">
                                    <a href="{{ route('books.show', $transaction->book->id ?? '#') }}" class="text-decoration-none text-dark">
                                        {{ $transaction->book->book_name ?? 'Unknown Book' }}
                                    </a>
                                </td>
                                <td>
                                    @if(strtolower($transaction->status) === 'borrowed')
                                        <span class="badge bg-warning text-dark">Borrowed</span>
                                    @else
                                        <span class="badge bg-success">Returned</span>
                                    @endif
                                </td>
                                <td>{{ $transaction->issue_date }}</td>
                                <td>{{ $transaction->due_date ?? $transaction->date_of_return }}</td>
                                <td>
                                    {{ $transaction->returned_on ?? '—' }}
                                </td>
                                <td class="text-end pe-3">
                                    @if($transaction->total_fine_paid > 0)
                                        <span class="badge bg-danger">${{ number_format($transaction->total_fine_paid, 2) }}</span>
                                    @else
                                        <span class="text-muted">$0.00</span>
                                    @endif
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