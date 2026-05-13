<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasColumn('bookings', 'time_slot_id')) {
            Schema::table('bookings', function (Blueprint $table) {
                $table->foreignId('time_slot_id')->nullable()->constrained('time_slots')->onDelete('set null');
            });
        }
    }
    public function down(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->dropForeign(['time_slot_id']);
            $table->dropColumn('time_slot_id');
        });
    }
};
