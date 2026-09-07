<?php
namespace Tests\Unit\Models;

use App\Models\LibUser;
use Database\Factories\DonorsFactory;
use Database\Factories\LibUsersFactory;
use Tests\TestCase;
use App\Models\Donation;
use App\Models\LibraryUser;
use Illuminate\Foundation\Testing\RefreshDatabase;

class DonationTest extends TestCase
{
    use RefreshDatabase;

    public function test_a_donation_belongs_to_a_user(): void
    {
        $user = LibUsersFactory::new()->create();
        $donation = DonorsFactory::new()->create(['user_id' => $user->id]);

        $this->assertInstanceOf(LibUser::class, $donation->user);
        $this->assertEquals($user->id, $donation->user->id);
    }
}
