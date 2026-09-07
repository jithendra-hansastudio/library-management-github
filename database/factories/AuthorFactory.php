<?php

namespace Database\Factories;

use App\Models\Author;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Author>
 */
class AuthorFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Author::class; // <-- Fixes "App\LibUsers not found"
    public function definition(): array
    {
        return [
            //
            "author_name" => $this->faker->name()
        ];
    }
}
