<?php

namespace App\Http\Controllers\User\instansi;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DukcapilController extends Controller
{
    public function index()
    {
        return view('pages.user.dukcapil.disdukcapil');
    }
}