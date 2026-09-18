<?php

namespace App\Http\Controllers;

use App\Models\ExtraCopy;
use Illuminate\Http\Request;

class ExtracopiesController extends Controller
{
    /**
     * Display a listing of extra copies records.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(){
        return json_decode(extracopies::all());
    }

    /**
     * Validate and record additional book copies in the database.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request){
        $validate = $request->validate([
            "book_id"           => "required|integer|exists:books,id",
            "count_of_books"    => "required|integer"
        ]);

        $extracopies =extracopies::create($validate);

           // Not doing this now
           // $transaction = Transaction::create($validated);

    return response()->json([
        'message' => 'Transaction recorded successfully!',
        'data' => $extracopies
    ], 201);

        return response()->json($extracopies);

    }
}
