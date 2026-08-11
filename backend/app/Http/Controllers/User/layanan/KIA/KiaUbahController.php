<?php

namespace App\Http\Controllers\User\layanan\KIA;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class KiaUbahController extends Controller
{
    public function index() {
        return view('pages.user.dukcapil.layanan.kia.ubah');
    }
}
