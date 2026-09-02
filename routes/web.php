<?php

use Illuminate\Support\Facades\Route;

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