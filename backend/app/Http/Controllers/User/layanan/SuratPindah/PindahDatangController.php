<?php

namespace App\Http\Controllers\User\layanan\SuratPindah;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class PindahDatangController extends Controller
{
    public function index() {
        return view('pages.user.dukcapil.layanan.pindah.datang');
    }
}
