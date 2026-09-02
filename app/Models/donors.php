<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class donors extends Model
{
    //
    
    // public $incrementing = true;    
    // protected $keyType = 'int';
    protected $table = "donors";
    protected $fillable = [
        'user_id',
        'book_type',
        'book_condition',
        'quantity_of_donations'
        ];
 
    public $timestamps = true;
    use HasFactory;
}
