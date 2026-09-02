<?php

namespace App\Http\Controllers;
use App\Models\author;
use Illuminate\Http\Request;

class AuthorController extends Controller
{
    //

    public function index(){
        return response()->json(author::all());
        
    }

    public function store(Request $request){
        
    $validated = request()->validate([
            "author_name" => "string|max:15",
        ]);

          // 2. Mass assign validated data to create product
        $author = author::create($validated);

        // 3. Return the created product with a 201 Created status code
        return response()->json($author, 201);
}
}