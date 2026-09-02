<?php

namespace Database\Factories;

use App\Models\transactions;
use App\Models\libusers;
use App\Models\books;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<transactions>
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
        
        'user_id'           => LibUsers::inRandomOrder()->first()?->id ?? libusers::factory(),
        "book_id"           => books::inRandomOrder()->first()?->id ?? books::factory(),
        "issue_date"        => $this->faker->date(),       
        "date_of_return"    => $this->faker->date(),   
        
        ];
    }
}
