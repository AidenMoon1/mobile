<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KtpRusak extends Model
{
    protected $fillable = [
        'user_id', 'nama', 'nik', 'no_kk', 'email', 'phone', 'keterangan',
        'provinsi', 'kota', 'kecamatan', 'kelurahan', 'alamat_lengkap', 'rt', 'rw',
        'file_rusak', 'file_kk', 'status'
    ];
}
