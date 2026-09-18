<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Book
 *
 * @property int $id
 * @property string $book_name
 * @property int $author_id
 * @property string $book_condition
 * @property int $year_of_publishing
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \App\Models\Author|null $author
 * @property-read \App\Models\ExtraCopy|null $extraCopy
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Transaction> $transactions
 */
class Book extends Model
{
    /**
     * Get the author that wrote the book.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function author(){
        return $this -> belongsTo(Author::class, 'id');
    }
    
    /**
     * Get the extra copy record associated with the book.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function extraCopy()
    {
        return $this->hasOne(ExtraCopy::class, 'book_id');
    }

    /**
     * Get all transactions associated with the book.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'book_id');
    }
    protected $table = "books";
    protected $fillable = [
        "book_name",
        "author_id", 
        "book_condition",
        "year_of_publishing"
        ];
    public $timestamps = true;
    use HasFactory;
    

}

