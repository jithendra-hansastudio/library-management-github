<?php
namespace Tests\Unit\Models;

use App\Models\ExtraCopy;
use Database\Factories\AuthorFactory;
use Database\Factories\BooksFactory;
use Database\Factories\ExtraCopiesFactory;
use Database\Factories\TransactionsFactory;
use Tests\TestCase;
use App\Models\Book;
use App\Models\Author;
use App\Models\Transaction;
use Illuminate\Foundation\Testing\RefreshDatabase;

class BookTest extends TestCase
{
    use RefreshDatabase;

    public function test_a_book_belongs_to_an_author(): void
    {
        $author = AuthorFactory::new()->create();
        $book = BooksFactory::new()->create(['id' => $author->id]);

        $this->assertInstanceOf(Author::class, $book->author);
        
        $this->assertEquals($author->id, $book->author->id);
    }

    public function test_a_book_has_one_idle_copy(): void
    {
        $book = BooksFactory::new()->create();
        $idleCopy = ExtraCopiesFactory::new()->create(['book_id' => $book->id]);

        $this->assertInstanceOf(ExtraCopy::class, $book->extraCopy);
        $this->assertEquals($idleCopy->id, $book->extraCopy->id);
    }

    public function test_a_book_has_many_transactions(): void
    {
        $book = BooksFactory::new()->create();
        $transaction = TransactionsFactory::new()->create(['book_id' => $book->id]);

        $this->assertTrue($book->transactions->contains($transaction));
    }
}
