<?php

namespace App\Http\Controllers;

use App\Models\LibUser;

use Illuminate\Http\Request;

class LibusersController extends Controller
{
    /**
     * Return a JSON response listing all library users for API consumption.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function api_index(){
        return response()->json(LibUser::all());
    
    }

    /**
     * Display a listing of library users ordered by name with transaction and donation counts.
     *
     * @return \Illuminate\Contracts\View\View
     */
    public function index()
    {
        $users = LibUser::withCount(['transactions', 'donations'])
                     ->orderBy('user_name')
                     ->get();

        return view('lib_users.index', compact('users'));
    }

    /**
     * Display a single library user profile with nested transactions (including books) and donations.
     *
     * @param int|string $id
     * @return \Illuminate\Contracts\View\View
     */
    public function show($id)
    {
        $user = LibUser::with([
            'transactions.book', // Eager-load nested book for transaction display
            'donations'
        ])->findOrFail($id);

        return view('lib_users.show', compact('user'));
    }

    /**
     * Validate and store a new library user in the database.
     *
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


    
    
    $user = LibUser::create($validated);
    return response()->json([
        'message' => 'User created successfully!',
        'data' => $user
    ], 201);

    }
}
