<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class transactions extends Model
{
    //
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
