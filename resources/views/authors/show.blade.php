<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ $author->author_name }} - Profile</title>
</head>
<body>

    <a href="{{ route('authors.index') }}">&larr; Back to Authors List</a>

    <h1>Author: {{ $author->author_name }}</h1>

    <h2>Books Written</h2>

    @if($author->books->isEmpty())
        <p>This author currently has no registered books.</p>
    @else
        <ul>
            @foreach ($author->books as $book)
                <li>
                    <a href="{{ route('books.show', $book->id) }}">
                        <strong>{{ $book->book_name }}</strong>
                    </a> 
                    <br>
                    <br>
                    — Year of Publication: 
                    {{ $book->year_of_publishing }}
                    <br>
                    — Book Condition: 
                    {{ $book->book_condition }}
                    <br>
                    <br>
                    <br>
                </li>
            @endforeach
        </ul>
    @endif

</body>
</html>