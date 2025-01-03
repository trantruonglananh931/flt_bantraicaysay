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
        Schema::table('users', function (Blueprint $table) {
            $table-> renameColumn('name','username');
            $table->string('full_name');
            $table->date('birth_year');
            $table->string('phone_number')->unique();
            $table->string('address');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table-> renameColumn('username','name');
            $table->dropColumn(['full_name', 'birth_year', 'phone_number', 'address']);
        });
    }
};
