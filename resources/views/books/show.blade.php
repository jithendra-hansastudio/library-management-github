<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $book->book_name }} - Details</title>
    <link rel="stylesheet" href="{{ asset('css/bootstrap.min.css') }}">    
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">

    <!-- Dynamic System Theme Injected Here -->
    @include('partials.theme-styles')
</head>
<body>
    <br>
    @include('partials.navbar')

    <main class="container my-5">
        <a href="{{ route('books.index') }}" class="btn btn-outline-secondary mb-4">&larr; Back to Books List</a>

        <h1 class="mb-4">{{ $book->book_name }}</h1>

        <ul class="list-unstyled">
            <li class="mb-3">
                <strong>Author:</strong> 
                {{ $book->author->author_name ?? 'Unknown Author' }}
            </li>
            <li class="mb-3">
                <strong>Condition:</strong> 
                {{ ucfirst($book->book_condition) }}
            </li>
            <li class="mb-3">
                <strong>Year Published:</strong> 
                {{ $book->year_of_publishing }}
            </li>
            <li class="mb-3">
                <strong>Added to Library:</strong> 
                {{ $book->created_at->format('F d, Y') }}
            </li>
            <li class="mb-3">
                <strong>Last Updated:</strong> 
                {{ $book->updated_at->diffForHumans() }}
            </li>
            <li class="mb-3">    
                <strong>Total Available Copies:</strong> 
                {{ $book->extraCopy ? ($book->extraCopy->count_of_books + 1) : 1 }}
            </li>
        </ul>

        <hr class="my-4">

        <!-- Borrowing Status placed outside of <ul> -->
        @php
            $activeBorrowings = $book->transactions->where('status', 'borrowed');
        @endphp

        @if($activeBorrowings->isNotEmpty())
            <h4 class="h5">Currently Borrowed:</h4>
            <ul class="list-group">
                @foreach($activeBorrowings as $transaction)
                    <li class="list-group-item">
                        Book borrowed with 
                        <a href="{{ route('transactions.show', $transaction->id) }}">
                            Transaction #{{ $transaction->id }}
                        </a> 
                        (Due on: {{ $transaction->date_of_return }})
                    </li>
                @endforeach
            </ul>
        @else
            <p class="text-muted">This book is currently not borrowed by anyone.</p>
        @endif
    </main>

</body>
</html>