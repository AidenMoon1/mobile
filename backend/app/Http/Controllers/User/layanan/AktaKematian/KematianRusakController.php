<?php

namespace App\Http\Controllers\User\layanan\AktaKematian;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class KematianRusakController extends Controller
{
    public function index() {
        return view('pages.user.dukcapil.layanan.kematian.rusak');
    }
}
