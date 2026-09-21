<?php

namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Http\Request;

class BooksController extends Controller
{
    /**
     * Display a listing of books along with their author details.
     *
     * @return \Illuminate\Contracts\View\View
     */
    public function index(){
        // 1. Overall System Summary Stats
        $totalTitles = Book::count();
        $books = Book::with('author')->get();
        return view('books.index', compact('books','totalTitles')); 
    }

    /**
     * Return a JSON response listing all books with author details.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function api_index(){       
        return response()->json(Book::with('author')->get());
    }

    /**
     * Validate and store a new book record in the database.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
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

    /**
     * Display details of a specific book by ID.
     *
     * @param int|string $id
     * @return \Illuminate\Contracts\View\View
     */
    public function show($id)
    {        
        $book = Book::with('author' ,'extraCopy','transactions')->findOrFail($id);
        return view('books.show', compact('book')); 
    }
}
    

    


