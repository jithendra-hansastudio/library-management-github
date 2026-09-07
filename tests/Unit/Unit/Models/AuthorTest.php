<?php
namespace Tests\Unit\Models;
use Database\Factories\AuthorFactory;
use Database\Factories\BooksFactory;
use Tests\TestCase;
use App\Models\Author;
use App\Models\Book;
use Illuminate\Foundation\Testing\RefreshDatabase;

class AuthorTest extends TestCase
{
    use RefreshDatabase;

    public function test_an_author_has_many_books(): void
    {
        $author = AuthorFactory::new()->create();
        $book = BooksFactory::new()->create(['id' => $author->id]);

        $this->assertTrue($author->books->contains($book));
        $this->assertInstanceOf(Book::class, $author->books->first());
    }
}
