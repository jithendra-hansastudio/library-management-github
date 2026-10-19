<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <!-- Brand Logo / Title -->
        <a class="navbar-brand fw-bold text-primary" href="{{ route('homescreen') }}">
            📚 Library System
        </a>

        <!-- Mobile Toggler Button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar Links -->
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                @auth
                    @php $userRole = auth()->user()->role ?? ''; @endphp

                    <!-- Home (All Authenticated Users) -->
                    <li class="nav-item">
                        <a class="nav-link {{ request()->routeIs('homescreen') ? 'active' : '' }}" href="{{ route('homescreen') }}">
                            Home
                        </a>
                    </li>

                    <!-- Books & Authors (Admin, Librarian) -->
                    @if(in_array($userRole, ['admin', 'librarian']))
                        <li class="nav-item">
                            <a class="nav-link {{ request()->routeIs('books.*') ? 'active' : '' }}" href="{{ route('books.index') }}">
                                Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link {{ request()->routeIs('authors.*') ? 'active' : '' }}" href="{{ route('authors.index') }}">
                                Authors
                            </a>
                        </li>
                    @endif

                    <!-- Transactions (Admin, Librarian, Member) -->
                    @if(in_array($userRole, ['admin', 'librarian', 'member']))
                        <li class="nav-item">
                            <a class="nav-link {{ request()->routeIs('transactions.*') ? 'active' : '' }}" href="{{ route('transactions.index') }}">
                                Transactions
                            </a>
                        </li>
                    @endif

                    <!-- Library Users & Settings (Admin Only) -->
                    @if($userRole === 'admin')
                        <li class="nav-item">
                            <a class="nav-link {{ request()->routeIs('lib_users.*') ? 'active' : '' }}" href="{{ route('lib_users.index') }}">
                                Library Users
                            </a>
                        </li>
                        <li class="nav-item ms-lg-2">
                            <a class="nav-link {{ request()->routeIs('settings.*') ? 'active' : '' }}" href="{{ route('settings.edit') }}">
                                Settings
                            </a>
                        </li>
                    @endif

                    <!-- Logout Form Button -->
                    <li class="nav-item ms-lg-2">
                        <form action="{{ route('logout') }}" method="POST" class="d-inline">
                            @csrf
                            <button type="submit" class="btn btn-outline-danger btn-sm px-3">
                                Logout
                            </button>
                        </form>
                    </li>
                @endauth
            </ul>
        </div>
    </div>
</nav>