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
        Schema::create('ktp_rusaks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Link ke akun
            $table->string('nama');
            $table->string('nik', 16);
            $table->string('no_kk', 16);
            $table->string('email');
            $table->string('phone');
            $table->text('keterangan')->nullable();
            
            // Alamat (Menyimpan Nama Wilayah)
            $table->string('provinsi');
            $table->string('kota');
            $table->string('kecamatan');
            $table->string('kelurahan');
            $table->text('alamat_lengkap');
            $table->string('rt', 5); // TAMBAHAN
            $table->string('rw', 5); // TAMBAHAN
            
            // Berkas
            $table->string('file_rusak');
            $table->string('file_kk');
            
            $table->string('status')->default('Menunggu Verifikasi');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ktp_rusaks');
    }
};
