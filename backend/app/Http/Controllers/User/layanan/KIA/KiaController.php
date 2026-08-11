<?php

namespace App\Http\Controllers\User\layanan\KIA;
use App\Http\Controllers\Controller;

class KiaController extends Controller {
    public function index() {
        return view('pages.user.dukcapil.layanan.kia');
    }
}