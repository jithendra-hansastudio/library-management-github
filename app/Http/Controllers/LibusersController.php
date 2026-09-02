<?php

namespace App\Http\Controllers;

use App\Models\libusers;

use Illuminate\Http\Request;

class LibusersController extends Controller
{
    //
    public function index(){
        return response()->json(libusers::all());
    
    }
    /**
     * Summary of store
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request){

    $validated = $request->validate([
            "user_name"             =>"required|string|max:20",    
            "date_of_birth"         =>"required|date",    
            "gender"                =>"required|in:male,female,prefer_not_to_say",    
            "address"               =>"required|string|max:40",    
            "role"                  =>"required|in:librarian,admin,member,visitor"
    ]);


    
    
    $user = libusers::create($validated);
    return response()->json([
        'message' => 'User created successfully!',
        'data' => $user
    ], 201);

    }
}
