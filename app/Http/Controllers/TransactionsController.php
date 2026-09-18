<?php

namespace App\Http\Controllers;

use App\Models\Transaction;
use Illuminate\Http\Request;
use Carbon\Carbon;

class TransactionsController extends Controller
{
    /**
     * Fetch all transactions via API and dynamically calculate overdue fines on-the-fly.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function api_index(){

    //FULL GEMINI
    $daily_fine_amt = 10;
    $today = Carbon::now()->startOfDay();

    // Fetch all transactions from the database
    $allTransactions = transactions::all();

    // Map through each transaction to dynamically calculate fines on-the-fly
    $calculatedTransactions = $allTransactions->map(function ($tx) use ($daily_fine_amt, $today) {
        
        $dueDate = Carbon::parse($tx->date_of_return)->startOfDay();

        if ($today->greaterThan($dueDate)) {
            $numOfDueDays = $dueDate->diffInDays($today); 
        } else {
            $numOfDueDays = 0; 
        }

        $total_fine = $numOfDueDays * $daily_fine_amt;

        // Attach calculated values to the object/array output without touching the database
        $tx->num_of_due_days = $numOfDueDays;
        $tx->fine_amount = $total_fine;

        return $tx;
    });

    return response()->json([
        'message' => 'Transactions fetched and fines calculated successfully!',
        'data' => $calculatedTransactions
    ], 200);
    }

    /**
     * Display a web listing of transactions ordered by latest issue date with user and book details.
     *
     * @return \Illuminate\Contracts\View\View
     */
    public function index()
    {
        $transactions = Transaction::with(['user', 'book'])
            ->latest('issue_date')
            ->get();

        return view('transactions.index', compact('transactions'));
    }

    /**
     * Display details of a specific transaction by ID.
     *
     * @param int|string $id
     * @return \Illuminate\Contracts\View\View
     */
    public function show($id)
    {
        $transaction = Transaction::with(['user', 'book'])->findOrFail($id);

        return view('transactions.show', compact('transaction'));
    }
            

    /**
     * Validate request data and record a new book borrow/checkout transaction.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request){
    
    $validated = request()->validate([
        "user_id"           => "required|integer|exists:lib_users,id",
        "book_id"           => "required|integer|exists:books,id"
    ]);

    //we're issuing the book now! so now is the issue date
    $issueDate = now();

    $date_of_return = $issueDate->copy()->addDays(14);   
    echo $validated["book_id"];


   $finalData = Transaction::create([    
     "user_id"         => $validated["user_id"],
     "book_id"         => $validated["book_id"],
     "status"          => 'borrowed',
     "issue_date"      => $issueDate->toDateString(),
     "date_of_return"  => $date_of_return->toDateString(),
   ]);    
   
   // Not doing this now
   // $transaction = Transaction::create($validated);

    return response()->json([
        'message' => 'Transaction recorded successfully!',
        'data' => $finalData
    ], 201);

   }

    /**
     * Update an existing transaction record when a book is returned and fine paid.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function edit(Request $request){
    
    //THE TRANSASCTION ID is the key, 
    // so all the further operations 
    // should happen based on that!

    $validated = request()->validate([
        "id"                => "required|string|max:5|exists:lib_users",
        "user_id"           => "required|string|max:5|exists:lib_users",
        "book_id"           => "required|string|max:5|exists:books",
        "returned_on"       => "nullable|date",
        "total_fine_paid"   => "nullable|float"
    ]);

    //we're issuing the book now! so now is the issue date
    $issueDate = now();

    $date_of_return = $issueDate->copy()->addDays(14);   
    echo $validated["books_id"];


   $finalData = transactions::create([    
     "status"            => 'returned',
     "returned_on"       => $validated["returned_on"],
     "total_fine_paid"   => $validated["total_fine_paid"],    
   ]);    
   
   // Not doing this now
   // $transaction = Transaction::create($validated);

    return response()->json([
        'message' => 'Transaction edited successfully!',
        'data' => $finalData
    ], 201);

   }
}
