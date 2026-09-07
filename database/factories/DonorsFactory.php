<?php

namespace Database\Factories;

use App\Models\Donation;
use App\Models\LibUser;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Donation>
 */
class DonorsFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Donation::class; // <-- Fixes "App\LibUsers not found"
    public function definition(): array
    {
        return [
            //
        
        'user_id'           => LibUsersFactory::new(),
        'book_type'=> $this->faker->randomElement(['new','already_exists','mixed']),
        'book_condition'=> $this->faker->randomElement(['good','mint','old', 'torn','mixed']),
        'quantity_of_donations' => $this->faker->numberBetween(1,15)
        ];
    }
}
