<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
// 1. Import Authenticatable instead of standard Model
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
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
class LibUser extends Authenticatable
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
    
    use HasFactory, Notifiable;
    
    protected $table = "lib_users";
        
    public $timestamps = true;
    protected $fillable = [
        "user_name",
        "date_of_birth",
        "gender",
        "address",
        "role",
        "password"
            ];
            protected $hidden = [
        'password',
        'remember_token',
    ];

            
}
