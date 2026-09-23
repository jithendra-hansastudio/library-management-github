<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authors Directory - Library Management</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Page Header -->
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
            <div>
                <h1 class="h2 mb-1">Authors Directory</h1>
                <p class="text-muted small mb-0">Browse all registered authors and their published titles</p>
            </div>
            <span class="badge bg-primary fs-6">Total Authors: {{ $authors->count() }}</span>
        </div>

        @if($authors->isEmpty())
            <div class="alert alert-info shadow-sm" role="alert">
                No authors found in the system database.
            </div>
        @else
            <!-- Responsive Grid of Author Cards -->
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                @foreach ($authors as $author)
                    <div class="col">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="card-body d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title mb-0">
                                        <a href="{{ route('authors.show', $author->id) }}" class="text-decoration-none text-dark stretched-link fw-bold">
                                            {{ $author->author_name }}
                                        </a>
                                    </h5>
                                    <span class="badge bg-secondary rounded-pill">
                                        {{ $author->books_count }} {{ Str::plural('Book', $author->books_count) }}
                                    </span>
                                </div>
                                <p class="card-text text-muted small mt-auto">
                                    Click to view author profile & published books &rarr;
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