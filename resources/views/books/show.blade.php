<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $book->book_name }} - Details</title>
</head>
<body>

    <a href="{{ route('books.index') }}">&larr; Back to Books List</a>

    <main>
        <h1>{{ $book->book_name }}</h1>

        <ul>
            <li>
                <strong>Author:</strong> 
                {{ $book->author->author_name ?? 'Unknown Author' }}
            </li>
            <br>
            <li>
                <strong>Condition:</strong> 
                {{ ucfirst($book->book_condition) }}
            </li>
            
            <br>
            <li>
                <strong>Year Published:</strong> 
                {{ $book->year_of_publishing }}
            </li>
            
            <br>
            <li>
                <strong>Added to Library:</strong> 
                {{ $book->created_at->format('F d, Y') }}
            </li>
            <br>

            <li>
                <strong>Last Updated:</strong> 
                {{ $book->updated_at->diffForHumans() }}
            </li>

            <br>
               <li>        
                @if($book->extraCopy)     
                <strong>Total Available Copies:</strong> 
                {{($book->extraCopy->count_of_books) + 1}}
                
                @else
                <strong>Total Available Copies:</strong> 
                {{ 1 }}
                
                @endif
                
          </li>
            <br>

            @php
                $activeBorrowings = $book->transactions->where('status', 'borrowed');
            @endphp

            
               @if($activeBorrowings->isNotEmpty())
        <h4>Currently Borrowed:</h4>
        
            @foreach($activeBorrowings as $transaction)
                
                    Book borrowed with
                    <a href="{{ route('transactions.show', $transaction->id) }}">
                        Transaction #{{ $transaction->id }}
                    </a>
                    (Due on: {{ $transaction->date_of_return }})
                
            @endforeach
        
    @else
        <p>This book is currently not borrowed by anyone.</p>
    @endif
             
                
            <br>
        </ul>

    </main>

</body>
</html>