<?php

namespace App\Http\Controllers\User\layanan\EKtp;
use App\Http\Controllers\Controller;

class KtpController extends Controller {
    public function index() {
        return view('pages.user.dukcapil.layanan.ktp');
    }
}