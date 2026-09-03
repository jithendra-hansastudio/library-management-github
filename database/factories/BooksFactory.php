<?php

namespace Database\Factories;

use App\Models\Book;
use App\Models\Author;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Book>
 */
class BooksFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [

        //GEMINI
        // Generate realistic, capitalized 3-word book titles (e.g. "The Great Adventure")
        'book_name' => ucwords($this->faker->words(3, true)),

        // Method 1: Automatically picks a random existing Author ID from database
        'author_id' => Author::inRandomOrder()->first()?->id ?? Author::factory(),
            
        // Method 2 (Alternative): Let Laravel auto-create a new Author if none provided
        // 'author_id' => Author::factory(),

        "book_condition"          => $this->faker-> randomElement(['good','mint','old', 'torn']),
        "year_of_publishing"      => $this->faker-> numberBetween(18, 65),
            //
        ];
    }
}
