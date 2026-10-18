<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Log - Library Management</title>
    <link rel="stylesheet" href="{{ asset('css/bootstrap.min.css') }}">    
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    
    {{-- Dynamic Theme Engine --}}
    @include('partials.theme-styles')
</head>
<body>
   <br>
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
            <div>
                <h1 class="h2 mb-1">Library Transactions Log</h1>
                <p class="text-secondary small mb-0">Track active borrowings, returns, and transaction records</p>
            </div>
            {{-- Primary Badge --}}
            <span class="badge bg-primary fs-6">Total Logs: {{ $transactions->count() }}</span>
        </div>

        @if($transactions->isEmpty())
            <div class="card p-4 text-center shadow-sm">
                <p class="mb-0 text-secondary">No transaction records found in the library database.</p>
            </div>
        @else
            <!-- Responsive Table View -->
            <div class="table-responsive card shadow-sm">
                <table class="table align-middle mb-0">
                    <thead>
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
                                    {{-- Primary accent link --}}
                                    <a href="{{ route('lib_users.show', $transaction->user->id ?? '#') }}" class="text-decoration-none text-primary fw-semibold">
                                        {{ $transaction->user->user_name ?? 'Unknown User' }}
                                    </a>
                                </td>
                                <td>
                                    {{-- Primary accent link --}}
                                    <a href="{{ route('books.show', $transaction->book->id ?? '#') }}" class="text-decoration-none text-primary">
                                        {{ $transaction->book->book_name ?? 'Unknown Book' }}
                                    </a>
                                </td>
                                <td>
                                    {{-- Status mapped to Primary & Secondary --}}
                                    @if(strtolower($transaction->status) === 'borrowed')
                                        <span class="badge bg-secondary">Borrowed</span>
                                    @else
                                        <span class="badge bg-primary">Returned</span>
                                    @endif
                                </td>
                                <td>{{ $transaction->issue_date }}</td>
                                <td>{{ $transaction->date_of_return ?? $transaction->due_date }}</td>
                                <td>
                                    @if($transaction->total_fine_paid > 0)
                                        <span class="badge bg-secondary">${{ number_format($transaction->total_fine_paid, 2) }}</span>
                                    @else
                                        <span class="text-secondary">$0.00</span>
                                    @endif
                                </td>
                                <td class="text-end pe-3">
                                    {{-- Primary Outline Button --}}
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