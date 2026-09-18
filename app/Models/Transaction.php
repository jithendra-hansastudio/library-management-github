<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Transaction
 *
 * @property int $id
 * @property int $user_id
 * @property int $book_id
 * @property string $status
 * @property string $issue_date
 * @property string $date_of_return
 * @property string|null $returned_on
 * @property float|null $total_fine_paid
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \App\Models\LibUser|null $user
 * @property-read \App\Models\Book|null $book
 */
class Transaction extends Model
{
    /**
     * Get the user associated with this transaction.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function user(){
        return $this -> belongsTo(LibUser::class, 'user_id');
    }
    
    /**
     * Get the book associated with this transaction.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function book(){
        return $this -> belongsTo(Book::class, 'book_id');
    }
    protected $table = "transactions";

    public $timestamps = true;
    
    protected $fillable = [
        "user_id",
        "book_id",
        
        "status",           // Added
        "issue_date",       // Added
        "date_of_return",   // Added
        "returned_on",      // Added
        "total_fine_paid"   // Added
        ];

        use HasFactory;
}
