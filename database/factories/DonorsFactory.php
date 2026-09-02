<?php

namespace Database\Factories;

use App\Models\Donors;
use App\Models\libusers;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Donors>
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
        
        'user_id'           => LibUsers::inRandomOrder()->first()?->id ?? libusers::factory(),
        'book_type'=> $this->faker->randomElement(['new','already_exists','mixed']),
        'book_condition'=> $this->faker->randomElement(['good','mint','old', 'torn','mixed']),
        'quantity_of_donations' => $this->faker->numberBetween(1,15)
        ];
    }
}
