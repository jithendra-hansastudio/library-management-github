<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Class LibUser
 *
 * @property int $id
 * @property string $user_name
 * @property string $date_of_birth
 * @property string $gender
 * @property string $address
 * @property string $role
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Transaction> $transactions
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Donation> $donations
 */
class LibUser extends Model
{
    /**
     * Get all transactions made by this library user.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function transactions(){
        return $this -> hasMany(Transaction::class, 'id');
    }

    /**
     * Get all donations made by this library user.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
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
