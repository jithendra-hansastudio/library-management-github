<?php

namespace Database\Factories;

use App\Models\LibUser;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<LibUser>
 */
class LibUsersFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
        "user_name"         => $this->faker->name(""),
        "date_of_birth"     => $this->faker->date(),
        "gender"            => $this->faker->randomElement(["male","female","prefer_not_to_say"]),
        "address"           =>substr($this->faker->address(), 0, 38),
        "role"              => $this->faker->randomElement(["librarian","admin","member","visitor"]),   
            //
        ];
    }
}
