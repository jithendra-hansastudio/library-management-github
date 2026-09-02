<?php

namespace Database\Seeders;

use Attribute;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
// use phpDocumentor\Reflection\DocBlock\Tags\Author;
use App\Models\Author;

class AuthorsSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Author::factory()->count(10)->create();
                //
    }
}
