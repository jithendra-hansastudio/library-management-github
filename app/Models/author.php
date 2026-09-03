<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Author extends Model
{
    protected $table = "authors";

    // protected $primarykey = "author_ID";   
    // public $incrementing = false;   
    // protected $keyType = 'string';
    protected $fillable = ["author_name"];
    public $timestamps = true;
    use HasFactory;
}
