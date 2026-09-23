<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Log - Library Management</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
            <div>
                <h1 class="h2 mb-1">Library Transactions Log</h1>
                <p class="text-muted small mb-0">Track active borrowings, returns, and transaction records</p>
            </div>
            <span class="badge bg-primary fs-6">Total Logs: {{ $transactions->count() }}</span>
        </div>

        @if($transactions->isEmpty())
            <div class="alert alert-info shadow-sm" role="alert">
                No transaction records found in the library database.
            </div>
        @else
            <!-- Responsive Table View -->
            <div class="table-responsive shadow-sm bg-white rounded border">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" class="ps-3">Tx #</th>
                            <th scope="col">Borrower</th>
                            <th scope="col">Book Title</th>
                            <th scope="col">Status</th>
                            <th scope="col">Issue Date</th>
                            <th scope="col">Return / Due Date</th>
                            <th scope="col">Fine Paid</th>
                            <th scope="col" class="text-end pe-3">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($transactions as $transaction)
                            <tr>
                                <td class="ps-3 fw-bold text-secondary">#{{ $transaction->id }}</td>
                                <td>
                                    <a href="{{ route('lib_users.show', $transaction->user->id ?? '#') }}" class="text-decoration-none text-dark fw-semibold">
                                        {{ $transaction->user->user_name ?? 'Unknown User' }}
                                    </a>
                                </td>
                                <td>
                                    <a href="{{ route('books.show', $transaction->book->id ?? '#') }}" class="text-decoration-none text-primary">
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
                                <td>{{ $transaction->date_of_return ?? $transaction->due_date }}</td>
                                <td>
                                    @if($transaction->total_fine_paid > 0)
                                        <span class="badge bg-danger">${{ number_format($transaction->total_fine_paid, 2) }}</span>
                                    @else
                                        <span class="text-muted">$0.00</span>
                                    @endif
                                </td>
                                <td class="text-end pe-3">
                                    <a href="{{ route('transactions.show', $transaction->id) }}" class="btn btn-sm btn-outline-primary">
                                        Details &rarr;
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