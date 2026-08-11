<?php

namespace App\Http\Controllers\User\layanan\KK;
use App\Http\Controllers\Controller;

class KkNumpangController extends Controller {
    public function index() {
        return view('pages.user.dukcapil.layanan.kk.numpang');
    }
}