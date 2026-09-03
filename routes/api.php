<?php


use App\Models\LibUser;
use App\Models\Author;
use App\Models\Book;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');


use App\Http\Controllers\AuthorController;
use App\Http\Controllers\BooksController;
use App\Http\Controllers\TransactionsController;
use App\Http\Controllers\LibusersController;
use App\Http\Controllers\ExtracopiesController;
use App\Http\Controllers\DonorsController;
//1
Route::get('/users', [LibusersController::class, 'index']);
Route::post('/users', [LibusersController::class, 'store']);
//2
Route::get('/authors', [AuthorController::class, 'index']);
Route::post('/authors', [AuthorController::class, 'store']);
//3
Route::get('/books', [BooksController::class, 'index']);
Route::post('/books', [BooksController::class, 'store']);
//4
Route::get('/rents', [TransactionsController::class, 'index']);
Route::post('/rents', [TransactionsController::class, 'store']);
//5
Route::get('/donations', [DonorsController::class, 'index']);
Route::post('/donations', [DonorsController::class, 'store']);
//6
Route::get('/extras', [ExtracopiesController::class, 'index']);
Route::post('/extras', [ExtracopiesController::class, 'store']);

Route::get('/test', function () {
    $book = Author::with('books')->first();
    dd($book->toArray()); // Dumps data and stops execution
});

Route::get('/authors-with-books', function () {
    return Author::with('books')->get(['id', 'author_name']);
});