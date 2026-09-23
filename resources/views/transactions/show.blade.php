<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction #{{ $transaction->id }} Details</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Back Navigation Button -->
        <a href="{{ route('transactions.index') }}" class="btn btn-outline-secondary mb-4">&larr; Back to Transactions Log</a>

        <!-- Transaction Details Card -->
        <div class="card shadow-sm border-0">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h1 class="h4 mb-0 text-primary fw-bold">Transaction Record #{{ $transaction->id }}</h1>
                @if(strtolower($transaction->status) === 'borrowed')
                    <span class="badge bg-warning text-dark fs-6">Borrowed</span>
                @else
                    <span class="badge bg-success fs-6">Returned</span>
                @endif
            </div>

            <div class="card-body">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded border">
                            <h5 class="h6 text-uppercase text-muted fw-bold mb-3">Borrower & Book Info</h5>
                            <ul class="list-group list-group-flush bg-transparent">
                                <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center ps-0 pe-0">
                                    <span class="fw-semibold">Borrower</span>
                                    <a href="{{ route('lib_users.show', $transaction->user->id ?? '#') }}" class="fw-bold text-decoration-none">
                                        {{ $transaction->user->user_name ?? 'Unknown User' }}
                                    </a>
                                </li>
                                <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center ps-0 pe-0">
                                    <span class="fw-semibold">Book Title</span>
                                    <a href="{{ route('books.show', $transaction->book->id ?? '#') }}" class="fw-bold text-decoration-none">
                                        {{ $transaction->book->book_name ?? 'Unknown Book' }}
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded border">
                            <h5 class="h6 text-uppercase text-muted fw-bold mb-3">Timeline & Fines</h5>
                            <ul class="list-group list-group-flush bg-transparent">
                                <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center ps-0 pe-0">
                                    <span class="fw-semibold">Issue Date</span>
                                    <span>{{ $transaction->issue_date }}</span>
                                </li>
                                <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center ps-0 pe-0">
                                    <span class="fw-semibold">Due Date</span>
                                    <span>{{ $transaction->date_of_return ?? $transaction->due_date }}</span>
                                </li>
                                <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center ps-0 pe-0">
                                    <span class="fw-semibold">Returned On</span>
                                    <span>{{ $transaction->returned_on ?? 'Not returned yet' }}</span>
                                </li>
                                <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center ps-0 pe-0">
                                    <span class="fw-semibold">Fine Paid</span>
                                    @if($transaction->total_fine_paid > 0)
                                        <span class="badge bg-danger fs-6">${{ number_format($transaction->total_fine_paid, 2) }}</span>
                                    @else
                                        <span class="text-muted">$0.00</span>
                                    @endif
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="mt-4 pt-3 border-top text-muted small d-flex justify-content-between align-items-center">
                    <span>Record Created: {{ $transaction->created_at ? $transaction->created_at->format('M d, Y H:i') : 'N/A' }}</span>
                </div>
            </div>
        </div>
    </main>

</body>
</html>