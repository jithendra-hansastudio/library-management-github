<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

/**
 * Class Author
 *
 * @property int $id
 * @property string $author_name
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Book> $books
 */
class Author extends Model
{
    /**
     * Get all books written by this author.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function books()
    {
        return $this->hasMany(Book::class, 'author_id');
    }

    protected $table = "authors";
    protected $fillable = ["author_name"];
    public $timestamps = true;
    
    use HasFactory;
}
