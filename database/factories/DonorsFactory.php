<?php

namespace Database\Factories;

use App\Models\Donor;
use App\Models\LibUser;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Donor>
 */
class DonorsFactory extends Factory
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
        'book_type'=> $this->faker->randomElement(['new','already_exists','mixed']),
        'book_condition'=> $this->faker->randomElement(['good','mint','old', 'torn','mixed']),
        'quantity_of_donations' => $this->faker->numberBetween(1,15)
        ];
    }
}
