<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Donation extends Model
{

    public function user(){
        return $this -> belongsTo(User::class, 'user_id');
    }
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
