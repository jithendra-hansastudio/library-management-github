<?php

namespace App\Http\Controllers;

use App\Models\transactions;
use Illuminate\Http\Request;
use Carbon\Carbon;

class TransactionsController extends Controller
{
    //
    public function index(){

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

            

    public function store(Request $request){
    
    $validated = request()->validate([
        "user_id"           => "required|integer|exists:lib_users,id",
        "book_id"           => "required|integer|exists:books,id"
    ]);

    //we're issuing the book now! so now is the issue date
    $issueDate = now();

    $date_of_return = $issueDate->copy()->addDays(14);   
    echo $validated["book_id"];


   $finalData = transactions::create([    
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
