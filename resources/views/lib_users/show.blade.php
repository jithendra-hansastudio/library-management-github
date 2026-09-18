<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ $user->user_name }} - Profile</title>
</head>
<body>

    <a href="{{ route('lib_users.index') }}">&larr; Back to Users List</a>

    <h1>User Profile: {{ $user->user_name }}</h1>

    <!-- User Details -->
    <ul>
        <li><strong>Role:</strong> {{ ucfirst($user->role) }}</li>
        <li><strong>Gender:</strong> {{ strtoupper($user->gender) }}</li>
        <li><strong>Date of Birth:</strong> {{ $user->date_of_birth }}</li>
        <li><strong>Address:</strong> {{ $user->address }}</li>
        <li><strong>Member Since:</strong> {{ $user->created_at->format('M d, Y') }}</li>
    </ul>

    <hr>

    <!-- Borrowing History (Transactions) -->
    <h2>Borrowing History</h2>
    @if($user->transactions->isEmpty())
        <p>No transaction history found for this user.</p>
    @else
        <ul>
            @foreach ($user->transactions as $transaction)
                <li>
                    Book: 
                    <a href="{{ route('books.show', $transaction->book->id ?? '#') }}">
                        <strong>{{ $transaction->book->book_name ?? 'Unknown Book' }}</strong>
                    </a>
                    <br>
                    Status: {{ ucfirst($transaction->status) }} | 
                    Issued: {{ $transaction->issue_date }} | 
                    Due: {{ $transaction->due_date }}
                    @if($transaction->returned_on)
                        | Returned: {{ $transaction->returned_on }}
                    @endif
                    @if($transaction->total_fine_paid > 0)
                        | Fine Paid: ${{ number_format($transaction->total_fine_paid, 2) }}
                    @endif
                </li>
                <br>
            @endforeach
        </ul>
    @endif

    <hr>

    <!-- Donations Made
    <h2>Donations Made</h2>
    @if($user->donations->isEmpty())
        <p>No donations made by this user.</p>
    @else
        <ul>
            @foreach ($user->donations as $donation)
                <li>
                    Quantity: {{ $donation->quantity_of_donations }} | 
                    Type: {{ ucfirst($donation->book_type) }} | 
                    Condition: {{ ucfirst($donation->book_condition) }} | 
                    Date: {{ $donation->created_at->format('M d, Y') }}
                </li>
            @endforeach
        </ul>
    @endif -->

</body>
</html>