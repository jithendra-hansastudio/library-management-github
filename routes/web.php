<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AuthorController;
use App\Http\Controllers\BooksController;
use App\Http\Controllers\LibusersController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\TransactionsController;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;



Route::get('/clear-views', function() {
    Artisan::call('view:clear');
    return "<h1>View cache cleared successfully!</h1><p>You can now go back and refresh your pages.</p>";
});

// --------------------------------------------------------------------------
// 1. Guest Routes (Public access)
// --------------------------------------------------------------------------
Route::middleware(['guest'])->group(function () {
    Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [AuthController::class, 'login']);
});

// Logout must be accessible to authenticated users
Route::post('/logout', [AuthController::class, 'logout'])->name('logout')->middleware('auth');

// Redirect root domain straight to /home
Route::get('/', function () {
    return redirect()->route('homescreen');
});

// --------------------------------------------------------------------------
// 2. Protected Routes with Role-Based Access Control (RBAC)
// --------------------------------------------------------------------------
Route::middleware(['auth'])->group(function () {

    Route::get('/settings_show', [SettingsController::class, 'api_index']);
    Route::get('/settings_show/{id}', [SettingsController::class, 'api_show']);

    // Dashboard / Home Screen (Accessible to all authenticated users)
    Route::view('/home', 'homescreen')->name('homescreen');

    // Books & Authors (Accessible to Admins and Librarians)
    Route::middleware(['role:admin,librarian'])->group(function () {
        Route::get('/books', [BooksController::class, 'index'])->name('books.index');
        Route::get('/books/{id}', [BooksController::class, 'show'])->name('books.show');

        Route::get('/authors', [AuthorController::class, 'index'])->name('authors.index');
        Route::get('/authors/{id}', [AuthorController::class, 'show'])->name('authors.show');
    });

    // Transactions History (Accessible to Admins, Librarians, and Members)
    Route::middleware(['role:admin,librarian,member'])->group(function () {
        Route::get('/transactions', [TransactionsController::class, 'index'])->name('transactions.index');
        Route::get('/transactions/{id}', [TransactionsController::class, 'show'])->name('transactions.show');
    });

    // Library Users Management & Settings (Strictly Admin Only)
    Route::middleware(['role:admin'])->group(function () {
        Route::get('/users', [LibusersController::class, 'index'])->name('lib_users.index');
        Route::get('/users/create', [LibusersController::class, 'create'])->name('lib_users.create');
        Route::post('/users', [LibusersController::class, 'store'])->name('lib_users.store');
        Route::get('/users/{id}', [LibusersController::class, 'show'])->name('lib_users.show');

        Route::get('/settings', [SettingsController::class, 'edit'])->name('settings.edit');
        Route::post('/settings', [SettingsController::class, 'update'])->name('settings.update');
    });
});