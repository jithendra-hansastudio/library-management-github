<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management Dashboard</title>
</head>
<body>
    <h1>Library Management System</h1>
    
    <nav>
        <h2>Main Directory</h2>
        <ul>
            <li>
                <a href="{{ route('books.index') }}">Browse Books</a>
            </li>
            <li>
                <a href="{{ route('authors.index') }}">Browse Authors</a>
            </li>
            <li>
                <a href="{{ route('lib_users.index') }}">Library Users Directory</a>
            </li>
            <li>
                <a href="{{ route('transactions.index') }}">Transaction Log</a>
            </li>
        </ul>
    </nav>
</body>
</html>