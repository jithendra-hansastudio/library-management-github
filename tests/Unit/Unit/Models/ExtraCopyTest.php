<?php
namespace Tests\Unit\Models;

use App\Models\ExtraCopy;
use Database\Factories\BooksFactory;
use Database\Factories\ExtraCopiesFactory;
use Tests\TestCase;
use App\Models\Book;
use Illuminate\Foundation\Testing\RefreshDatabase;

class ExtraCopyTest extends TestCase
{
    use RefreshDatabase;

    public function test_an_idle_copy_belongs_to_a_book(): void
    {
        $book = BooksFactory::new()->create();
        $idleCopy = ExtraCopiesFactory::new()->create(['book_id' => $book->id]);

        $this->assertInstanceOf(Book::class, $idleCopy->book);
        $this->assertEquals($book->id, $idleCopy->book->id);
    }
}