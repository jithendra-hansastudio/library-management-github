<?php


use App\Http\Controllers\AuthController;
use App\Http\Controllers\AuthorController;
use App\Http\Controllers\BooksController;
use App\Http\Controllers\TransactionsController;
use App\Http\Controllers\LibusersController;
use App\Http\Controllers\ExtracopiesController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\DonorsController;

use App\Models\LibUser;
use App\Models\Author;
use App\Models\Book;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;



//Login
Route::post('/login', [AuthController::class, 'apiLogin']);

Route::middleware('auth:sanctum')->group(function () {
    // Authenticated User Info
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // 1. Users
    Route::get('/users', [LibusersController::class, 'api_index']);
    Route::get('/users/{id}', [LibusersController::class, 'api_show']);
    Route::post('/users', [LibusersController::class, 'store']);

    // 2. Authors
    Route::get('/authors', [AuthorController::class, 'api_index']);
    Route::get('/authors/{id}', [AuthorController::class, 'api_show']);
    Route::post('/authors', [AuthorController::class, 'store']);

    // 3. Books
    Route::get('/books', [BooksController::class, 'api_index']);
    Route::get('/books/{id}', [BooksController::class, 'api_show']);
    Route::post('/books', [BooksController::class, 'store']);

    // 4. Transactions
    Route::get('/transactions', [TransactionsController::class, 'api_index']);
    Route::get('/transactions/{id}', [TransactionsController::class, 'api_show']);
    Route::post('/transactions', [TransactionsController::class, 'store']);

     // Route::get('/donors/{id}', [DonorsController::class, 'api_show']);
    // 5. Donations
    Route::get('/donations', [DonorsController::class, 'api_index']);
    Route::post('/donations', [DonorsController::class, 'store']);
   
    // 6. Extra Copies
    Route::get('/extras', [ExtracopiesController::class, 'index']);
    // Route::get('/extracopies/{id}', [ExtracopiesController::class, 'api_show']);
    Route::post('/extras', [ExtracopiesController::class, 'store']);

    // 7. Settings
    Route::get('/settings', [SettingsController::class, 'show']);
    Route::get('/settings/{id}', [SettingsController::class, 'api_show']);
});

// Keep debug/test routes open or secure as needed
Route::get('/authors-with-books', function () {
    return Author::with('books')->get(['id', 'author_name']);
});