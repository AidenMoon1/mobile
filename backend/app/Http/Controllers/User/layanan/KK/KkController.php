<?php

namespace App\Http\Controllers\User\layanan\KK;
use App\Http\Controllers\Controller;

class KkController extends Controller {
    public function index() {
        return view('pages.user.dukcapil.layanan.kk');
    }
}