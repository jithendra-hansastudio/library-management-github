<?php

namespace Database\Factories;

use App\Models\Transaction;
use App\Models\LibUser;
use App\Models\Book;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Transaction>
 */
class TransactionsFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            //
        
        'user_id'           => LibUser::inRandomOrder()->first()?->id ?? LibUser::factory(),
        "book_id"           => Book::inRandomOrder()->first()?->id ?? Book::factory(),
        "issue_date"        => $this->faker->date(),       
        "date_of_return"    => $this->faker->date(),   
        
        ];
    }
}
