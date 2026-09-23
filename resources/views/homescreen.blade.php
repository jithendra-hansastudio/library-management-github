<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management Dashboard</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.ts'])
</head>
<body class="bg-light">
    @include('partials.navbar')

    <main class="container my-5">
        <!-- Hero Section -->
        <div class="bg-white rounded-3 shadow-sm p-4 p-md-5 mb-5 border">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <span class="badge bg-primary mb-2 px-3 py-2">Library Portal</span>
                    <h1 class="display-5 fw-bold text-dark mb-2">Library Management System</h1>
                    <p class="lead text-muted mb-4">
                        Welcome to the central library dashboard. Easily browse books, manage registered members, inspect author catalog, and track active borrowings.
                    </p>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="{{ route('books.index') }}" class="btn btn-primary btn-lg px-4">Browse Books &rarr;</a>
                        <a href="{{ route('transactions.index') }}" class="btn btn-outline-secondary btn-lg px-4">View Transactions</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Quick Navigation Cards -->
        <h2 class="h4 mb-4 pb-2 border-bottom">System Directories</h2>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
            <!-- Books Card -->
            <div class="col">
                <div class="card h-100 shadow-sm border-0 transition-hover">
                    <div class="card-body p-4 d-flex flex-column">
                        <div class="mb-3">
                            <span class="badge bg-primary p-3 rounded-3 fs-5">📚</span>
                        </div>
                        <h4 class="h5 card-title fw-bold">Books Catalog</h4>
                        <p class="card-text text-muted small flex-grow-1">
                            Explore available book titles, availability, and condition reports.
                        </p>
                        <a href="{{ route('books.index') }}" class="btn btn-sm btn-outline-primary mt-3 stretched-link">
                            Go to Books Catalog &rarr;
                        </a>
                    </div>
                </div>
            </div>

            <!-- Authors Card -->
            <div class="col">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4 d-flex flex-column">
                        <div class="mb-3">
                            <span class="badge bg-success p-3 rounded-3 fs-5">✍️</span>
                        </div>
                        <h4 class="h5 card-title fw-bold">Authors Directory</h4>
                        <p class="card-text text-muted small flex-grow-1">
                            Browse author profiles, bio details, and total published works.
                        </p>
                        <a href="{{ route('authors.index') }}" class="btn btn-sm btn-outline-success mt-3 stretched-link">
                            Go to Authors &rarr;
                        </a>
                    </div>
                </div>
            </div>

            <!-- Users Card -->
            <div class="col">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4 d-flex flex-column">
                        <div class="mb-3">
                            <span class="badge bg-info text-dark p-3 rounded-3 fs-5">👥</span>
                        </div>
                        <h4 class="h5 card-title fw-bold">Library Users</h4>
                        <p class="card-text text-muted small flex-grow-1">
                            Manage members, librarians, and administrative user profiles.
                        </p>
                        <a href="{{ route('lib_users.index') }}" class="btn btn-sm btn-outline-info mt-3 stretched-link">
                            Go to Users &rarr;
                        </a>
                    </div>
                </div>
            </div>

            <!-- Transactions Card -->
            <div class="col">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4 d-flex flex-column">
                        <div class="mb-3">
                            <span class="badge bg-warning text-dark p-3 rounded-3 fs-5">📋</span>
                        </div>
                        <h4 class="h5 card-title fw-bold">Transaction Log</h4>
                        <p class="card-text text-muted small flex-grow-1">
                            Review borrowing activities, return histories, and fine records.
                        </p>
                        <a href="{{ route('transactions.index') }}" class="btn btn-sm btn-outline-warning text-dark mt-3 stretched-link">
                            Go to Transactions &rarr;
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

</body>
</html>