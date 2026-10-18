<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('lib_users')->onDelete('cascade');
            
            // Appearance & Presets
            $table->boolean('is_dark_mode')->default(false);
            $table->string('theme_preset')->default('ocean');     // ocean, emerald, sunset, slate, amber, cyber
            $table->string('corner_style')->default('smooth');    // sharp, smooth, pill
            
            // Layout & Spacing
            $table->integer('shadow_level')->default(1);          // 0 = none, 1 = subtle, 2 = medium, 3 = deep
            $table->float('font_scale')->default(1.0);            // 0.8 to 1.3
            $table->boolean('is_compact_density')->default(false);

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('settings');
    }
};