<?php

namespace App\Http\Controllers;

use App\Models\Donor;
use Illuminate\Http\Request;

class DonorsController extends Controller
{
    //


    public function index(){
        return json_decode(Donor::all());
    }
    public function store(Request $request){
        
        $validated = $request->validate([
                'user_id'               => 'required|integer|exists:authors,id',
                'book_type'             => 'required|in:new,already_exists,mixed',
                "quantity_of_donations" => "required|integer",        
                'book_condition'        => 'required|in:good,mint,old,torn',
    
        ]);

    
        // Strips null fields so the database 'anonymos' default takes effect
        $donations = Donor::create(array_filter($validated));
         

         return response()->json([
        'message' => 'Transaction recorded successfully!',
        'data' => $donations
    ], 201);

        // return redirect()->back()->with('success', 'Book added successfully!');
}
}
