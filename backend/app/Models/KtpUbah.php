<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KtpUbah extends Model
{
    protected $fillable = [
        'user_id', 'nama', 'nik', 'no_kk', 'email', 'phone', 'jenis_perubahan',
        'provinsi', 'kota', 'kecamatan', 'kelurahan', 'alamat_lengkap', 'rt', 'rw',
        'file_kk_baru', 'file_pendukung', 'status'
    ];
}
