<?php

namespace App\Http\Controllers;
use App\Models\Author;
use Illuminate\Http\Request;

class AuthorController extends Controller
{
    //

    public function index()
    {
        $authors = Author::withCount('books')->orderBy('author_name')->get();
        return view('authors.index', compact('authors'));
    }
    public function api_index(){
        return response()->json(Author::all());
    }

    // Display a single author and all their books
    public function show($id)
    {
        $author = Author::with('books')->findOrFail($id);
        return view('authors.show', compact('author'));
    }


    public function store(Request $request){
        
    $validated = request()->validate([
            "author_name" => "string|max:15",
        ]);

          // 2. Mass assign validated data to create product
        $author = Author::create($validated);

        // 3. Return the created product with a 201 Created status code
        return response()->json($author, 201);
}
}