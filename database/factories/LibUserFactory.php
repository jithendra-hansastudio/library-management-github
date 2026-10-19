<?php

namespace Database\Factories;

use App\Models\LibUser;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash; 

/**
 * @extends Factory<LibUser>
 */
class LibUserFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = LibUser::class; 
    public function definition(): array
    {
        return [
        
        "user_name"     => substr($this->faker->name(), 0, 20),
        "date_of_birth"     => $this->faker->date(),
        "gender"            => $this->faker->randomElement(["male","female","prefer_not_to_say"]),
        "address"           =>substr($this->faker->address(), 0, 38),
        "role"              => $this->faker->randomElement(["librarian","admin","member","visitor"]),   
        "password" => Hash::make("password123"),
            //
        ];
    }
}
