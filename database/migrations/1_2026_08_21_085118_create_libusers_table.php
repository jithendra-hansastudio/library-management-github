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
        Schema::create('lib_users', function (Blueprint $table) {
            $table->id();
            $table->string('user_name',20);
            $table->date('date_of_birth');
            $table->enum('gender',["male","female","prefer_not_to_say"]);
            $table->string('address',40);
            $table->enum('role',["librarian","admin","member","visitor"]);
            $table->timestamps();
            $table->softDeletes();
        });
    }



    

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('lib_users');
    }
};
