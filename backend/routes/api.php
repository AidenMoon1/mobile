<?php

use Illuminate\Support\Facades\Route;
use App\Models\Aduan;
use App\Models\KtpHilang;
use App\Models\KtpRusak;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Endpoint untuk berita (Mock Data untuk visualisasi)
Route::get('/berita', function () {
    return response()->json([
        [
            'id' => 1,
            'title' => 'Diskominfo Meluncurkan Aplikasi Baru',
            'content' => 'Dalam rangka meningkatkan pelayanan publik, Dinas Komunikasi dan Informatika Sukabumi meluncurkan aplikasi pelayanan terpadu hari ini.',
            'image_url' => null,
            'created_at' => now()->toDateTimeString(),
        ],
        [
            'id' => 2,
            'title' => 'Sosialisasi Keamanan Informasi',
            'content' => 'Diskominfo Sukabumi menyelenggarakan sosialisasi mengenai pentingnya menjaga keamanan data pribadi dan informasi penting di era digital.',
            'image_url' => null,
            'created_at' => now()->subDays(1)->toDateTimeString(),
        ],
        [
            'id' => 3,
            'title' => 'Pelatihan Literasi Digital Masyarakat',
            'content' => 'Sebanyak 100 peserta dari berbagai kalangan mengikuti pelatihan literasi digital guna meningkatkan kecerdasan bermedia sosial di Sukabumi.',
            'image_url' => null,
            'created_at' => now()->subDays(2)->toDateTimeString(),
        ]
    ]);
});

// Ambil semua aduan dari database MySQL
Route::get('/aduan', function () {
    return response()->json(Aduan::latest()->get());
});

// Simpan aduan baru ke database MySQL
Route::post('/aduan', function (Request $request) {
    $validated = $request->validate([
        'title' => 'required|string|max:255',
        'category' => 'required|string',
        'description' => 'required|string',
    ]);

    $aduan = Aduan::create([
        'title' => $validated['title'],
        'category' => $validated['category'],
        'description' => $validated['description'],
        'status' => 'Menunggu',
    ]);

    return response()->json([
        'status' => 'success',
        'data' => $aduan
    ], 200);
});

// ==========================================
// PORTAL LAYANAN TERPADU - API DISDUKCAPIL
// ==========================================

// 1. Simpan KTP Hilang dari Mobile
Route::post('/disdukcapil/ktp/hilang', function (Request $request) {
    // Validasi data (file opsional untuk mempermudah simulator jika file belum diimplementasikan sepenuhnya)
    $validated = $request->validate([
        'nama' => 'required|string|max:255',
        'nik' => 'required|string|size:16',
        'no_kk' => 'required|string|size:16',
        'email' => 'required|email',
        'phone' => 'required|string',
        'provinsi' => 'required|string',
        'kota' => 'required|string',
        'kecamatan' => 'required|string',
        'kelurahan' => 'required|string',
        'alamat_lengkap' => 'required|string',
        'rt' => 'required|string|max:5',
        'rw' => 'required|string|max:5',
    ]);

    // Handle files (simulasi default jika file kosong)
    $pathKehilangan = 'berkas/placeholder_hilang.jpg';
    $pathKk = 'berkas/placeholder_kk.jpg';

    if ($request->hasFile('file_kehilangan')) {
        $pathKehilangan = $request->file('file_kehilangan')->store('berkas/ktp_hilang', 'public');
    }
    if ($request->hasFile('file_kk')) {
        $pathKk = $request->file('file_kk')->store('berkas/kk_ktp_hilang', 'public');
    }

    $userId = $request->input('user_id') ?? (\App\Models\User::first()->id ?? 1);

    $data = KtpHilang::create([
        'user_id' => $userId,
        'nama' => $validated['nama'],
        'nik' => $validated['nik'],
        'no_kk' => $validated['no_kk'],
        'email' => $validated['email'],
        'phone' => $validated['phone'],
        'keterangan' => $request->input('keterangan'),
        'provinsi' => $validated['provinsi'],
        'kota' => $validated['kota'],
        'kecamatan' => $validated['kecamatan'],
        'kelurahan' => $validated['kelurahan'],
        'alamat_lengkap' => $validated['alamat_lengkap'],
        'rt' => $validated['rt'],
        'rw' => $validated['rw'],
        'file_kehilangan' => $pathKehilangan,
        'file_kk' => $pathKk,
        'status' => 'Menunggu Verifikasi',
    ]);

    return response()->json([
        'status' => 'success',
        'message' => 'Laporan KTP Hilang berhasil dikirim!',
        'data' => $data
    ], 200);
});

// 2. Simpan KTP Rusak dari Mobile
Route::post('/disdukcapil/ktp/rusak', function (Request $request) {
    $validated = $request->validate([
        'nama' => 'required|string|max:255',
        'nik' => 'required|string|size:16',
        'no_kk' => 'required|string|size:16',
        'email' => 'required|email',
        'phone' => 'required|string',
        'provinsi' => 'required|string',
        'kota' => 'required|string',
        'kecamatan' => 'required|string',
        'kelurahan' => 'required|string',
        'alamat_lengkap' => 'required|string',
        'rt' => 'required|string|max:5',
        'rw' => 'required|string|max:5',
    ]);

    $pathRusak = 'berkas/placeholder_rusak.jpg';
    $pathKk = 'berkas/placeholder_kk.jpg';

    if ($request->hasFile('file_rusak')) {
        $pathRusak = $request->file('file_rusak')->store('berkas/ktp_rusak', 'public');
    }
    if ($request->hasFile('file_kk')) {
        $pathKk = $request->file('file_kk')->store('berkas/kk_ktp_rusak', 'public');
    }

    $userId = $request->input('user_id') ?? (\App\Models\User::first()->id ?? 1);

    $data = KtpRusak::create([
        'user_id' => $userId,
        'nama' => $validated['nama'],
        'nik' => $validated['nik'],
        'no_kk' => $validated['no_kk'],
        'email' => $validated['email'],
        'phone' => $validated['phone'],
        'keterangan' => $request->input('keterangan'),
        'provinsi' => $validated['provinsi'],
        'kota' => $validated['kota'],
        'kecamatan' => $validated['kecamatan'],
        'kelurahan' => $validated['kelurahan'],
        'alamat_lengkap' => $validated['alamat_lengkap'],
        'rt' => $validated['rt'],
        'rw' => $validated['rw'],
        'file_rusak' => $pathRusak,
        'file_kk' => $pathKk,
        'status' => 'Menunggu Verifikasi',
    ]);

    return response()->json([
        'status' => 'success',
        'message' => 'Laporan KTP Rusak berhasil dikirim!',
        'data' => $data
    ], 200);
});
