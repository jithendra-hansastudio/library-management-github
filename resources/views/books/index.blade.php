<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Books - Library Management</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
            <h1 class="h2 mb-0">Books Catalog</h1>
            <span class="badge bg-primary fs-6">Total Titles: {{ $totalTitles }}</span>
        </div>

        @if($books->isEmpty())
            <div class="alert alert-info" role="alert">
                No books found in the library database.
            </div>
        @else
            <!-- Responsive Grid of Cards -->
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                @foreach ($books as $book)
                    <div class="col">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">
                                    <a href="{{ route('books.show', $book->id) }}" class="text-decoration-none text-dark stretched-link">
                                        {{ $book->book_name }}
                                    </a>
                                </h5>
                                <p class="card-text text-muted mb-0 mt-auto">
                                    <small>Author: {{ $book->author->author_name ?? 'Unknown Author' }}</small>
                                </p>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        @endif
    </main>

</body>
</html>