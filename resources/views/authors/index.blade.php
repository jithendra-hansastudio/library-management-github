<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Authors List</title>
</head>
<body>

    <h1>Authors Directory</h1>

    @if($authors->isEmpty())
        <p>No authors found in the system.</p>
    @else
        <ul>
            @foreach ($authors as $author)
                <li>
                    <a href="{{ route('authors.show', $author->id) }}">
                        <strong>{{ $author->author_name }}</strong>
                    </a>
                    — Total Books: {{ $author->books_count }}
                </li>
            @endforeach
        </ul>
    @endif

</body>
</html>