<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Library Users</title>
</head>
<body>

    <h1>Library Users Directory</h1>

    @if($users->isEmpty())
        <p>No users found.</p>
    @else
        <ul>
            @foreach ($users as $user)
                <li>
                    <a href="{{ route('lib_users.show', $user->id) }}">
                        <strong>{{ $user->user_name }}</strong>
                    </a> 
                    - {{ ucfirst($user->role) }}
                    
                </li>
            @endforeach
        </ul>
    @endif

</body>
</html>