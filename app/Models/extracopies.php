<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class extracopies extends Model
{
    //
    protected $table = "extracopies";

    // protected $primary_key = "id";
    // public $incrementing = true;
    // protected $keyType = 'string';      
    
    public $timestamps = true;
    protected $fillable = [
        "book_id",        
        "count_of_books"
    ];

    use HasFactory;

}
