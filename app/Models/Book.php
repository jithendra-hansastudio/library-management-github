<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Book extends Model
{
    
    public function author(){
        return $this -> hasOne(Author::class, 'author_id');
    }
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

