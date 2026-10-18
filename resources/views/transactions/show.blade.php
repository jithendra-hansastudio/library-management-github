<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction #{{ $transaction->id }} Details</title>
    <link rel="stylesheet" href="{{ asset('css/bootstrap.min.css') }}">    
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">

    {{-- Dynamic Theme Engine --}}
    @include('partials.theme-styles')
</head>
<body>
   <br>
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Back Navigation Button -->
        <a href="{{ route('transactions.index') }}" class="btn btn-outline-secondary mb-4">&larr; Back to Transactions Log</a>

        <!-- Main Transaction Container Card -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header py-3 px-4 d-flex justify-content-between align-items-center">
                <h1 class="h4 mb-0 text-primary fw-bold">Transaction Record #{{ $transaction->id }}</h1>
                @if(strtolower($transaction->status) === 'borrowed')
                    <span class="badge bg-secondary fs-6 px-3 py-2">Borrowed</span>
                @else
                    <span class="badge bg-primary fs-6 px-3 py-2">Returned</span>
                @endif
            </div>

            <div class="card-body p-4">
                <div class="row g-4">
                    <!-- Borrower & Book Info Box -->
                    <div class="col-md-6">
                        <div class="p-3 rounded border h-100" style="border-color: var(--app-border) !important; background-color: rgba(0,0,0,0.01);">
                            <h2 class="h6 text-uppercase text-muted fw-bold mb-3">Borrower & Book Info</h2>
                            <div class="mb-3 d-flex justify-content-between align-items-center">
                                <span class="text-muted">Borrower</span>
                                <a href="{{ route('lib_users.show', $transaction->user->id ?? '#') }}" class="fw-bold text-decoration-none" style="color: var(--app-primary);">
                                    {{ $transaction->user->user_name ?? 'Unknown User' }}
                                </a>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-muted">Book Title</span>
                                <a href="{{ route('books.show', $transaction->book->id ?? '#') }}" class="fw-bold text-decoration-none text-end" style="color: var(--app-primary); max-width: 60%;">
                                    {{ $transaction->book->book_name ?? 'Unknown Book' }}
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Timeline & Fines Box -->
                    <div class="col-md-6">
                        <div class="p-3 rounded border h-100" style="border-color: var(--app-border) !important; background-color: rgba(0,0,0,0.01);">
                            <h2 class="h6 text-uppercase text-muted fw-bold mb-3">Timeline & Fines</h2>
                            <div class="mb-3 d-flex justify-content-between align-items-center">
                                <span class="text-muted">Issue Date</span>
                                <span class="fw-semibold">{{ $transaction->issue_date }}</span>
                            </div>
                            <div class="mb-3 d-flex justify-content-between align-items-center">
                                <span class="text-muted">Due Date</span>
                                <span class="fw-semibold">{{ $transaction->date_of_return ?? $transaction->due_date }}</span>
                            </div>
                            <div class="mb-3 d-flex justify-content-between align-items-center">
                                <span class="text-muted">Returned On</span>
                                <span class="fw-semibold text-secondary">{{ $transaction->returned_on ?? 'Not returned yet' }}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-muted">Fine Paid</span>
                                @if($transaction->total_fine_paid > 0)
                                    <span class="badge bg-secondary px-2 py-1">${{ number_format($transaction->total_fine_paid, 2) }}</span>
                                @else
                                    <span class="fw-semibold text-secondary">$0.00</span>
                                @endif
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer Record Date -->
                <div class="mt-4 pt-3 border-top text-muted small d-flex justify-content-between align-items-center" style="border-color: var(--app-border) !important;">
                    <span>Record Created: {{ $transaction->created_at ? $transaction->created_at->format('M d, Y H:i') : 'N/A' }}</span>
                </div>
            </div>
        </div>
    </main>
</body>
</html>