<?php


use App\Models\LibUser;
use App\Models\Author;
use App\Models\Book;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;


//Login
Route::post('/login', [AuthController::class, 'apiLogin']);

Route::middleware('auth:sanctum')->group(function () {
    // Authenticated User Info
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // 1. Users
    Route::get('/users', [LibusersController::class, 'api_index']);
    Route::post('/users', [LibusersController::class, 'store']);

    // 2. Authors
    Route::get('/authors', [AuthorController::class, 'api_index']);
    Route::post('/authors', [AuthorController::class, 'store']);

    // 3. Books
    Route::get('/books', [BooksController::class, 'api_index']);
    Route::post('/books', [BooksController::class, 'store']);

    // 4. Transactions
    Route::get('/transactions', [TransactionsController::class, 'api_index']);
    Route::post('/transactions', [TransactionsController::class, 'store']);

    // 5. Donations
    Route::get('/donations', [DonorsController::class, 'index']);
    Route::post('/donations', [DonorsController::class, 'store']);

    // 6. Extra Copies
    Route::get('/extras', [ExtracopiesController::class, 'index']);
    Route::post('/extras', [ExtracopiesController::class, 'store']);

    // 7. Settings
    Route::get('/settings', [SettingsController::class, 'api_index']);
});

// Keep debug/test routes open or secure as needed
Route::get('/authors-with-books', function () {
    return Author::with('books')->get(['id', 'author_name']);
});