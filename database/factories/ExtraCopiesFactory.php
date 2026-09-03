<?php

namespace Database\Factories;

use App\Models\Book;
use App\Models\ExtraCopy;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ExtraCopy>
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
        
        'book_id'           => Book::inRandomOrder()->first()?->id ?? Book::factory(),    
        "count_of_books"    => $this->faker->randomNumber("3","50"),
        ];
    }
}
