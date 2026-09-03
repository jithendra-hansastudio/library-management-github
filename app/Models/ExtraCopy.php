<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ExtraCopy extends Model
{
    //
    protected $table = "extracopies";


    public function book(){
        return $this -> belongsTo(Book::class, 'book_id');
    }
    public $timestamps = true;
    protected $fillable = [
        "book_id",        
        "count_of_books"
    ];

    use HasFactory;

}
