<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transactions Log</title>
</head>
<body>

    <h1>Library Transactions</h1>

    @if($transactions->isEmpty())
        <p>No transaction records found.</p>
    @else
        <ul>
            @foreach ($transactions as $transaction)
                <li>
                    <a href="{{ route('transactions.show', $transaction->id) }}">
                        <strong>Transaction #{{ $transaction->id }}</strong>
                    </a>
                    — 
                    User: <strong>{{ $transaction->user->user_name ?? 'Unknown User' }}</strong> | 
                    Book: <strong>{{ $transaction->book->book_name ?? 'Unknown Book' }}</strong> | 
                    Status: {{ ucfirst($transaction->status) }}
                </li>
            @endforeach
        </ul>
    @endif

</body>
</html>