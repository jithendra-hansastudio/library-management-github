<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Author extends Model
{
    

public function books()
{

    return $this->hasMany(Book::class, 'author_id');
}

    protected $table = "authors";
    protected $fillable = ["author_name"];
    public $timestamps = true;
    
    use HasFactory;
}
