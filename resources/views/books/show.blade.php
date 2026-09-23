<!-- <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $book->book_name }} - Details</title>
    
     <link href="https://cdn.jsdelivr.net/stylesheet/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
      
</head>
<body class="bg-dark">
        
    <a href="{{ route('books.index') }}">&larr; Back to Books List</a>


    
    
    <main>
        <div class = "container my-5 mx-auto">
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
</div>
    </main>

</body>
</html> -->


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $book->book_name }} - Details</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    
</head>
<body class="bg-light">
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

