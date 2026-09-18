<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Donation
 *
 * @property int $id
 * @property int $user_id
 * @property string $book_type
 * @property string $book_condition
 * @property int $quantity_of_donations
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \App\Models\LibUser|null $user
 */
class Donation extends Model
{
    /**
     * Get the library user who made this donation.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function user(){
        return $this -> belongsTo(LibUser::class, 'user_id');
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
