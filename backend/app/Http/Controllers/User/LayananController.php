<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class LayananController extends Controller
{
    /**
     * Menampilkan Halaman Direktori Semua Layanan
     */
    public function index()
    {
        // Mengarah ke resources/views/pages/user/layanan.blade.php
        return view('pages.user.layanan');
    }
}