<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transaction #{{ $transaction->id }} Details</title>
</head>
<body>

    <a href="{{ route('transactions.index') }}">&larr; Back to Transactions Log</a>

    <h1>Transaction Details #{{ $transaction->id }}</h1>

    <ul>
        <li>
            <strong>Borrower:</strong> 
            <a href="{{ route('lib_users.show', $transaction->user->id ?? '#') }}">
                {{ $transaction->user->user_name ?? 'Unknown User' }}
            </a>
        </li>

        <li>
            <strong>Book Borrowed:</strong> 
            <a href="{{ route('books.show', $transaction->book->id ?? '#') }}">
                {{ $transaction->book->book_name ?? 'Unknown Book' }}
            </a>
        </li>

        <li><strong>Status:</strong> {{ ucfirst($transaction->status) }}</li>
        <li><strong>Issue Date:</strong> {{ $transaction->issue_date }}</li>
        <li><strong>Due Date:</strong> {{ $transaction->due_date }}</li>
        <li><strong>Returned On:</strong> {{ $transaction->returned_on ?? 'Not returned yet' }}</li>
        <li><strong>Fine Paid:</strong> ${{ number_format($transaction->total_fine_paid, 2) }}</li>
        <li><strong>Created Record:</strong> {{ $transaction->created_at->format('M d, Y H:i') }}</li>
    </ul>

</body>
</html>