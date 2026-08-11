<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KtpPindah extends Model
{
    protected $fillable = [
        'user_id', 'nama', 'nik', 'no_kk', 'email', 'phone', 'keterangan',
        'provinsi', 'kota', 'kecamatan', 'kelurahan', 'alamat_lengkap', 
        'rt', 'rw', // TAMBAHKAN INI
        'file_skpwni', 'file_pendukung', 'status'
    ];
}
