<?php

namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Http\Request;

class BooksController extends Controller
{
    public function index(){
        // $books = books::all();
        // return json_encode($books);
        return response()->json(Book::all());
    }
    public function store(Request $request){

        $validated = $request->validate([
                'book_name'             => 'required|string|max:30',
                'author_id'            => 'required|integer|exists:authors,id',
                'book_condition'       => 'required|in:good,mint,old,torn',
                'year_of_publishing'   => 'required|integer',
        ]);

    
        // Strips null fields so the database 'anonymos' default takes effect
        Book::create(array_filter($validated));

        // return redirect()->back()->with('success', 'Book added successfully!');
         return response()->json([
        'message' => 'Book Added successfully!',
        'data' => $validated
    ], 201);
}

    }
    //


