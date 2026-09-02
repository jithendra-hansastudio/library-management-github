<?php

namespace Database\Seeders;

use App\Models\donors;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DonorsSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        donors::factory()->count(10)->create();
    }
}
