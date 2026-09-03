<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    

    public function user(){
        return $this -> belongsTo(LibUser::class, 'user_id');
    }
    
    public function book(){
        return $this -> belongsTo(Book::class, 'book_id');
    }
    protected $table = "transactions";

    public $timestamps = true;
    
    protected $fillable = [
        "user_id",
        "book_id",
        
        "status",           // Added
        "issue_date",       // Added
        "date_of_return",   // Added
        "returned_on",      // Added
        "total_fine_paid"   // Added
        ];

        use HasFactory;
}
