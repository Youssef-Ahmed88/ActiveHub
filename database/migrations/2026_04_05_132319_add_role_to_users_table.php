<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // We add role after the email column so it's logically grouped
            // enum() restricts the value to only these three options at the DB level
            // default('player') means anyone who registers is a player unless specified otherwise
            $table->enum('role', ['admin', 'player', 'staff'])->default('player')->after('email');
        });
    }

    public function down(): void
    {
        // This runs if we ever need to undo this migration (roll back)
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('role');
        });
    }
};
