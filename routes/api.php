<?php


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
Route::post('/putAuthors', [AuthorController::class, 'store']);
//3
Route::get('/getBooks', [BooksController::class, 'index']);
Route::post('/addBooks', [BooksController::class, 'store']);
//4
Route::get('/seeRents', [TransactionsController::class, 'index']);
Route::post('/addRents', [TransactionsController::class, 'store']);
//5
Route::get('/seeDonations', [DonorsController::class, 'index']);
Route::post('/addDonations', [DonorsController::class, 'store']);
//6
Route::get('/seeExtraCopies', [ExtracopiesController::class, 'index']);
Route::post('/addExtraCopies', [ExtracopiesController::class, 'store']);
