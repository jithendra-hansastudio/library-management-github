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
        Schema::create('extracopies', function (Blueprint $table) {
            // $table->string('author_ID',15);
            // $table->foreign('author_ID')->references('author_ID')->on('authors')->onDelete('cascade');
           
            // $table->string("books_id",5);
            // $table->foreign("books_id")->references("books_id")->on("books")->onDelete("cascade");

            $table->id();
            $table->foreignId('book_id')->constrained('books')->onDelete('cascade');
        
            $table->integer('count_of_books');

            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('extracopies');
    }
};
