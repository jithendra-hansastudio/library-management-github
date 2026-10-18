<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $user->user_name }} - User Profile</title>
    <link rel="stylesheet" href="{{ asset('css/bootstrap.min.css') }}">    
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    <!-- Dynamic System Theme Injected Here -->
    @include('partials.theme-styles')
</head>
<body>
    <br>
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Back Navigation Button -->
        <a href="{{ route('lib_users.index') }}" class="btn btn-outline-secondary mb-4">&larr; Back to Users List</a>

        <!-- Profile Header Card -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header py-3 px-4 d-flex justify-content-between align-items-center">
                <h1 class="h3 mb-0 text-primary fw-bold">{{ $user->user_name }}</h1>
                <span class="badge bg-secondary fs-6 px-3 py-2">{{ ucfirst($user->role) }}</span>
            </div>
            
            <div class="card-body p-4">
                <div class="row g-4">
                    <!-- Left Column: Personal Info -->
                    <div class="col-md-6">
                        <div class="p-3 rounded border h-100" style="border-color: var(--app-border) !important; background-color: rgba(0,0,0,0.01);">
                            <h6 class="text-uppercase text-muted fw-bold small mb-3">Personal Details</h6>
                            <div class="mb-3 d-flex justify-content-between">
                                <span class="text-muted">Gender</span>
                                <span class="fw-semibold">{{ strtoupper($user->gender) }}</span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span class="text-muted">Date of Birth</span>
                                <span class="fw-semibold">{{ $user->date_of_birth }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Account Info -->
                    <div class="col-md-6">
                        <div class="p-3 rounded border h-100" style="border-color: var(--app-border) !important; background-color: rgba(0,0,0,0.01);">
                            <h6 class="text-uppercase text-muted fw-bold small mb-3">Account Information</h6>
                            <div class="mb-3 d-flex justify-content-between">
                                <span class="text-muted">Address</span>
                                <span class="fw-semibold text-end text-truncate" style="max-width: 60%;">{{ $user->address }}</span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span class="text-muted">Member Since</span>
                                <span class="fw-semibold">{{ $user->created_at->format('M d, Y') }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Borrowing History Section -->
        <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
            <h2 class="h4 mb-0">Borrowing History</h2>
        </div>

        @if($user->transactions->isEmpty())
            <div class="alert alert-info shadow-sm" role="alert">
                No transaction history found for this user.
            </div>
        @else
            <div class="table-responsive shadow-sm rounded border mb-4">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th scope="col" class="ps-3 py-3">Book</th>
                            <th scope="col" class="py-3">Status</th>
                            <th scope="col" class="py-3">Issue Date</th>
                            <th scope="col" class="py-3">Due Date</th>
                            <th scope="col" class="py-3">Returned On</th>
                            <th scope="col" class="text-end pe-3 py-3">Fine Paid</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($user->transactions as $transaction)
                            <tr>
                                <td class="ps-3 fw-bold">
                                    <a href="{{ route('books.show', $transaction->book->id ?? '#') }}" class="text-decoration-none" style="color: var(--app-primary);">
                                        {{ $transaction->book->book_name ?? 'Unknown Book' }}
                                    </a>
                                </td>
                                <td>
                                    @if(strtolower($transaction->status) === 'borrowed')
                                        <span class="badge bg-warning text-dark px-2 py-1">Borrowed</span>
                                    @else
                                        <span class="badge bg-success px-2 py-1">Returned</span>
                                    @endif
                                </td>
                                <td>{{ $transaction->issue_date }}</td>
                                <td>{{ $transaction->due_date ?? $transaction->date_of_return }}</td>
                                <td>{{ $transaction->returned_on ?? '—' }}</td>
                                <td class="text-end pe-3">
                                    @if($transaction->total_fine_paid > 0)
                                        <span class="badge bg-danger px-2 py-1">${{ number_format($transaction->total_fine_paid, 2) }}</span>
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