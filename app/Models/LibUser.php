<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LibUser extends Model
{
    //
    protected $table = "lib_users";
    
    // public $incrementing = true;

    // protected $keyType = 'int';
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
