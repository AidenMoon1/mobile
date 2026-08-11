<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
        // Kita kirim data kosong dulu agar tampilan tidak error
        return view('pages.home', [
            'berkasAktif' => false,
            'jumlahPengajuan' => 0
        ]);
    }
}