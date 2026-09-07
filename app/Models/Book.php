<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Book extends Model
{
    
    public function author(){
        return $this -> belongsTo(Author::class, 'id');
    }
    
    public function extraCopy()
    {
        return $this->hasOne(ExtraCopy::class, 'book_id');
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'book_id');
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

