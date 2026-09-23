<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $author->author_name }} - Author Profile</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Back Navigation Button -->
        <a href="{{ route('authors.index') }}" class="btn btn-outline-secondary mb-4">&larr; Back to Authors List</a>

        <!-- Author Header Card -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body p-4 d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-uppercase text-muted fw-bold small">Author Profile</span>
                    <h1 class="h2 mb-0 mt-1 text-primary">{{ $author->author_name }}</h1>
                </div>
                <span class="badge bg-primary fs-6 rounded-pill">
                    {{ $author->books->count() }} Published {{ Str::plural('Book', $author->books->count()) }}
                </span>
            </div>
        </div>

        <!-- Books Written Section -->
        <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
            <h2 class="h4 mb-0">Books Written</h2>
        </div>

        @if($author->books->isEmpty())
            <div class="alert alert-info shadow-sm" role="alert">
                This author currently has no registered books in the library.
            </div>
        @else
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                @foreach ($author->books as $book)
                    <div class="col">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title mb-2">
                                    <a href="{{ route('books.show', $book->id) }}" class="text-decoration-none text-dark stretched-link fw-bold">
                                        {{ $book->book_name }}
                                    </a>
                                </h5>
                                <div class="mt-auto pt-3 border-top d-flex justify-content-between align-items-center small text-muted">
                                    <span>Year: {{ $book->year_of_publishing }}</span>
                                    <span class="badge bg-secondary">{{ ucfirst($book->book_condition) }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        @endif
    </main>

</body>
</html>