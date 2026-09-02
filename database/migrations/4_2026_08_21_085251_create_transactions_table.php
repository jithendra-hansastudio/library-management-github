<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();          
            
            $table->foreignId('user_id')->constrained('lib_users')->onDelete('cascade'); 
            $table->foreignId('book_id')->constrained('books')->onDelete('cascade');
            
            $table->enum("status",["borrowed","returned"])->default("borrowed");
            $table->date("issue_date");
            $table->date("date_of_return")->nullable();
            $table->date("returned_on")->nullable();
            $table->integer("num_of_due_days")->default(0);
            $table->float("total_fine_paid")->default(0);
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
