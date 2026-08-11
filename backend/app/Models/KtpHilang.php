<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KtpHilang extends Model
{
    protected $fillable = [
        'user_id', 'nama', 'nik', 'no_kk', 'email', 'phone', 'keterangan',
        'provinsi', 'kota', 'kecamatan', 'kelurahan', 'alamat_lengkap', 'rt', 'rw',
        'file_kehilangan', 'file_kk', 'status'
    ];
}