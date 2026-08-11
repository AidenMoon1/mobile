<?php

namespace App\Http\Controllers\User\layanan\Akta;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AktaUbahController extends Controller
{
    public function index() {
        return view('pages.user.dukcapil.layanan.akta.ubah');
    }
}
