<?php

use App\Http\Controllers\AuthorController;
use App\Http\Controllers\BooksController;
use App\Http\Controllers\LibusersController;
use App\Http\Controllers\TransactionsController;
use Illuminate\Support\Facades\Route;

//routes i Created
Route::view('/home', 'homescreen')->name('homescreen');
// Books
Route::get('/books', [BooksController::class, 'index'])->name('books.index');
Route::get('/books/{id}', [BooksController::class, 'show'])->name('books.show');

// Authors
Route::get('/authors', [AuthorController::class, 'index'])->name('authors.index');
Route::get('/authors/{id}', [AuthorController::class, 'show'])->name('authors.show');

// Library Users
Route::get('/users', [LibusersController::class, 'index'])->name('lib_users.index');
Route::get('/users/{id}', [LibusersController::class, 'show'])->name('lib_users.show');

// Transactions (Borrow / Return History)
Route::get('/transactions', [TransactionsController::class, 'index'])->name('transactions.index');
Route::get('/transactions/{id}', [TransactionsController::class, 'show'])->name('transactions.show');




Route::inertia('/', 'Welcome')->name('home');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::inertia('dashboard', 'Dashboard')->name('dashboard');
});

require __DIR__.'/settings.php';

// use App\Http\Controllers\AuthorController;
// use App\Http\Controllers\BooksController;

// Route::get('/authors', [AuthorController::class, 'index']);
// Route::post('/putauthors', [AuthorController::class, 'store']);

// Route::get('/getBooks', [AuthorController::class, 'index']);
// Route::post('/addBooks', [AuthorController::class, 'store']);