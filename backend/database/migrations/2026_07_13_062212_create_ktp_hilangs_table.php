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
        Schema::create('ktp_hilangs', function (Blueprint $table) {
            $table->id();
            // KUNCI UTAMA: Menghubungkan form ini dengan akun yang login
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); 
            
            // Data Pemohon
            $table->string('nama');
            $table->string('nik', 16);
            $table->string('no_kk', 16);
            $table->string('email');
            $table->string('phone');
            $table->text('keterangan')->nullable();

            // Data Alamat
            $table->string('provinsi');
            $table->string('kota');
            $table->string('kecamatan');
            $table->string('kelurahan');
            $table->text('alamat_lengkap');
            $table->string('rt', 5);
            $table->string('rw', 5);

            // Nama File Berkas
            $table->string('file_kehilangan');
            $table->string('file_kk');
            
            // Status Otomatis
            $table->string('status')->default('Menunggu Verifikasi');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ktp_hilangs');
    }
};
