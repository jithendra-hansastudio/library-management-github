<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class books extends Model
{
    //
    

    // public $incrementing = true;    
    // protected $keyType = 'int';
    protected $table = "books";
    protected $fillable = [
        "book_name",
        "author_id", 
        "book_condition",
        "year_of_publishing"
        ];
    public $timestamps = true;
    use HasFactory;
    

}

