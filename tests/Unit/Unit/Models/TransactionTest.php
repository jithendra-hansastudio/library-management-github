<?php
namespace Tests\Unit\Models;

use App\Models\LibUser;
use Database\Factories\BooksFactory;
use Database\Factories\LibUsersFactory;
use Database\Factories\TransactionsFactory;
use Tests\TestCase;
use App\Models\Transaction;
use App\Models\LibraryUser;
use App\Models\Book;
use Illuminate\Foundation\Testing\RefreshDatabase;

class TransactionTest extends TestCase
{
    use RefreshDatabase;

    public function test_a_transaction_belongs_to_a_user(): void
    {
        $user = LibUsersFactory::new()->create();
        $transaction = TransactionsFactory::new()->create(['user_id' => $user->id]);

        $this->assertInstanceOf(LibUser::class, $transaction->user);
        $this->assertEquals($user->id, $transaction->user->id);
    }

    public function test_a_transaction_belongs_to_a_book(): void
    {
        $book = BooksFactory::new()->create();
        $transaction = TransactionsFactory::new()->create(['book_id' => $book->id]);

        $this->assertInstanceOf(Book::class, $transaction->book);
        $this->assertEquals($book->id, $transaction->book->id);
    }
}
