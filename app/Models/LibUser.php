<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LibUser extends Model
{
    public function transactions(){
        return $this -> hasMany(Transaction::class, 'id');
    }
    public function donations(){
        return $this -> hasMany(Donation::class, 'user_id');
    }

    protected $table = "lib_users";
        
    public $timestamps = true;
    protected $fillable = [
        "user_name",
        "date_of_birth",
        "gender",
        "address",
        "role"
            ];

            use HasFactory;
}
