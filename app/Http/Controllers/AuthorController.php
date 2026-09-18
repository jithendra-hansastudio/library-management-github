<?php

namespace App\Http\Controllers;
use App\Models\Author;
use Illuminate\Http\Request;

/**
 * Class AuthorController
 *
 * Handles management of authors including listing, API responses, single author view, and creation.
 */
class AuthorController extends Controller
{
    /**
     * Display a listing of authors with their book counts.
     *
     * @return \Illuminate\Contracts\View\View
     */
    public function index()
    {
        $authors = Author::withCount('books')->orderBy('author_name')->get();
        return view('authors.index', compact('authors'));
    }

    /**
     * Display a JSON listing of all authors for API requests.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function api_index(){
        return response()->json(Author::all());
    }

    /**
     * Display a single author and all their associated books.
     *
     * @param int|string $id
     * @return \Illuminate\Contracts\View\View
     */
    public function show($id)
    {
        $author = Author::with('books')->findOrFail($id);
        return view('authors.show', compact('author'));
    }

    /**
     * Validate and store a new author record in the database.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
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