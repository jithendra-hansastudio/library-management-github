<?php

namespace Database\Seeders;

use App\Models\transactions;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class TransactionssSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        transactions::factory()->count(10)->create();
    }
}
