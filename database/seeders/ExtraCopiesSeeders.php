<?php

namespace Database\Seeders;

use App\Models\ExtraCopy;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ExtraCopiesSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        ExtraCopy::factory()->count(10)->create();
    }
}
