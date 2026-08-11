<?php

namespace App\Http\Controllers\User\layanan\Akta;
use App\Http\Controllers\Controller;

class AktaController extends Controller {
    public function index() {
        return view('pages.user.dukcapil.layanan.akta');
    }
}