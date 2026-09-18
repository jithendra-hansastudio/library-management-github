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
        </ul>

    </main>

</body>
</html>