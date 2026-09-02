<?php

namespace Database\Factories;

use App\Models\books;
use App\Models\extracopies;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<extracopies>
 */
class ExtraCopiesFactory extends Factory
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
        
        'book_id'           => books::inRandomOrder()->first()?->id ?? books::factory(),    
        "count_of_books"    => $this->faker->randomNumber("3","50"),
        ];
    }
}
