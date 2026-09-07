<?php
namespace Tests\Unit\Models;

use App\Http\Controllers\DonorsController;
use App\Models\LibUser;
use Database\Factories\DonorsFactory;
use Database\Factories\LibUsersFactory;
use Database\Factories\TransactionsFactory;
use Tests\TestCase;
use App\Models\Transaction;
use App\Models\Donation;
use Illuminate\Foundation\Testing\RefreshDatabase;

class LibraryUserTest extends TestCase
{
    use RefreshDatabase;

    public function test_a_user_has_many_transactions(): void
    {
        $user = LibUsersFactory::new()->create();
        $transaction = TransactionsFactory::new()->create(['user_id' => $user->id]);
        
        $this->assertTrue($user->transactions->contains($transaction));
        $this->assertInstanceOf(Transaction::class, $user->transactions->first());
    }

    public function test_a_user_has_many_donations(): void
    {
        $user = LibUsersFactory::new()->create();
        $donation = DonorsFactory::new()->create(['user_id' => $user->id]);

        $this->assertTrue($user->donations->contains($donation));
        $this->assertInstanceOf(Donation::class, $user->donations->first());
    }
}
