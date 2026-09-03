<?php

namespace App\Http\Controllers;
use App\Models\Author;
use Illuminate\Http\Request;

class AuthorController extends Controller
{
    //

    public function index(){
        return response()->json(Author::all());
        
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