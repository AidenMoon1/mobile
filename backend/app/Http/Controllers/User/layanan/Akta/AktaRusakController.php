<?php

namespace App\Http\Controllers\User\layanan\Akta;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AktaRusakController extends Controller
{
    public function index() {
        return view('pages.user.dukcapil.layanan.akta.rusak');
    }
}
