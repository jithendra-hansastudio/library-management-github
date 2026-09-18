<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ExtraCopy
 *
 * @property int $id
 * @property int $book_id
 * @property int $count_of_books
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \App\Models\Book|null $book
 */
class ExtraCopy extends Model
{
    protected $table = "extracopies";

    /**
     * Get the book associated with these extra copies.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function book(){
        return $this -> belongsTo(Book::class, 'book_id');
    }
    public $timestamps = true;
    protected $fillable = [
        "book_id",        
        "count_of_books"
    ];

    use HasFactory;

}
