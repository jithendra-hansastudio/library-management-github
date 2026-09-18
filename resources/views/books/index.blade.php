<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Books - Library Management</title>
</head>
<body>
    <h1>Books</h1>

    @if($books->isEmpty())
        <p>No books found.</p>
    @else
        <ul>
            @foreach ($books as $book)
                <li>
                    <!-- Link to individual show page -->
                    <a href="{{ route('books.show', $book->id) }}">
                        <strong>{{ $book->book_name }}</strong>
                    </a> 
                    by {{ $book->author->author_name ?? 'Unknown Author' }}

                    <br><br>
                </li>
            @endforeach
        </ul>
    @endif
</body>
</html>