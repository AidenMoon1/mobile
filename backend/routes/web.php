<?php

use Illuminate\Support\Facades\Route;

// 1. Import Global & Auth Controllers
use App\Http\Controllers\HomeController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\User\AboutController;
use App\Http\Controllers\User\LayananController;
use App\Http\Controllers\User\PengaduanController;

// 2. Import Instansi Controllers
use App\Http\Controllers\User\instansi\DukcapilController;

// 3. Import Layanan E-KTP Controllers
use App\Http\Controllers\User\layanan\EKtp\KtpController;
use App\Http\Controllers\User\layanan\EKtp\KtpHilangController;
use App\Http\Controllers\User\layanan\EKtp\KtpPindahController;
use App\Http\Controllers\User\layanan\EKtp\KtpRusakController;
use App\Http\Controllers\User\layanan\EKtp\KtpUbahController;

// 4. Import Layanan Kartu Keluarga Controllers
use App\Http\Controllers\User\layanan\KK\KkController;
use App\Http\Controllers\User\layanan\KK\KkBaruController;
use App\Http\Controllers\User\layanan\KK\KkPisahController;
use App\Http\Controllers\User\layanan\KK\KkHilangController;
use App\Http\Controllers\User\layanan\KK\KkRusakController;
use App\Http\Controllers\User\layanan\KK\KkUbahController;
use App\Http\Controllers\User\layanan\KK\KkNumpangController;

// 5. Import Layanan Akta Controllers
use App\Http\Controllers\User\layanan\Akta\AktaController;
use App\Http\Controllers\User\layanan\Akta\AktaBaruController;
use App\Http\Controllers\User\layanan\Akta\AktaHilangController;
use App\Http\Controllers\User\layanan\Akta\AktaRusakController;
use App\Http\Controllers\User\layanan\Akta\AktaUbahController;

// 6. Import Layanan KIA Controllers
use App\Http\Controllers\User\layanan\KIA\KiaController;
use App\Http\Controllers\User\layanan\KIA\KiaBaruController;
use App\Http\Controllers\User\layanan\KIA\KiaHilangController;
use App\Http\Controllers\User\layanan\KIA\KiaRusakController;
use App\Http\Controllers\User\layanan\KIA\KiaUbahController;

// 7. Import Layanan Pindah Controllers
use App\Http\Controllers\User\layanan\SuratPindah\PindahController;
use App\Http\Controllers\User\layanan\SuratPindah\PindahDalamController;
use App\Http\Controllers\User\layanan\SuratPindah\PindahKeluarController;
use App\Http\Controllers\User\layanan\SuratPindah\PindahDatangController;

// 8. Import Layanan Akta Kematian Controllers
use App\Http\Controllers\User\layanan\AktaKematian\AktaKematianController;
use App\Http\Controllers\User\layanan\AktaKematian\KematianBaruController;
use App\Http\Controllers\User\layanan\AktaKematian\KematianHilangController;
use App\Http\Controllers\User\layanan\AktaKematian\KematianRusakController;
use App\Http\Controllers\User\layanan\AktaKematian\KematianUbahController;

/*
|--------------------------------------------------------------------------
| 1. HALAMAN PUBLIK (Akses Tanpa Login)
|--------------------------------------------------------------------------
*/
Route::get('/', [HomeController::class, 'index'])->name('home');
Route::get('/tentang', [AboutController::class, 'index'])->name('about');
Route::get('/pengaduan', [PengaduanController::class, 'index'])->name('pengaduan');
Route::get('/layanan', [LayananController::class, 'index'])->name('layanan');

/*
|--------------------------------------------------------------------------
| 2. SISTEM AUTH (Guest Only)
|--------------------------------------------------------------------------
*/
Route::middleware('guest')->group(function () {
    Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [AuthController::class, 'login'])->name('login.post');
    Route::post('/register', [AuthController::class, 'register'])->name('register');
});

/*
|--------------------------------------------------------------------------
| 3. HALAMAN USER TERPROTEKSI (Wajib Login)
|--------------------------------------------------------------------------
*/
Route::middleware('auth')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
    
    // Management Profil & Keamanan
    Route::get('/user/profile', [AuthController::class, 'showProfile'])->name('user.profile');
    Route::post('/user/profile/update', [AuthController::class, 'updateProfile'])->name('user.profile.update');
    Route::get('/user/security', [AuthController::class, 'showSecurity'])->name('user.security');
    Route::post('/user/security/update', [AuthController::class, 'updatePassword'])->name('user.security.update');
    
    // Dashboards
    Route::get('/dashboard', function() { return "Halaman Dashboard Warga"; })->name('dashboard');
    Route::get('/admin/dashboard', function() { return "Halaman Dashboard Admin"; })->name('admin.dashboard');

    /*
    |--- 3.1 LAYANAN DISDUKCAPIL ---
    */
    Route::prefix('disdukcapil')->group(function () {
        
        // Utama Dinas
        Route::get('/', [DukcapilController::class, 'index'])->name('disdukcapil');

        // Grup E-KTP
        Route::prefix('ktp')->group(function () {        
            Route::get('/', [KtpController::class, 'index'])->name('layanan.ktp');
            
            Route::get('/hilang', [KtpHilangController::class, 'index'])->name('layanan.ktp.hilang');
            Route::post('/hilang/store', [KtpHilangController::class, 'store'])->name('layanan.ktp.hilang.store');
            
            Route::get('/rusak', [KtpRusakController::class, 'index'])->name('layanan.ktp.rusak');
            Route::post('/rusak/store', [KtpRusakController::class, 'store'])->name('layanan.ktp.rusak.store');
            
            Route::get('/pindah', [KtpPindahController::class, 'index'])->name('layanan.ktp.pindah');
            Route::post('/pindah/store', [KtpPindahController::class, 'store'])->name('layanan.ktp.pindah.store');
            
            Route::get('/ubah', [KtpUbahController::class, 'index'])->name('layanan.ktp.ubah');
            Route::post('/ubah/store', [KtpUbahController::class, 'store'])->name('layanan.ktp.ubah.store');
        });

        // Grup Kartu Keluarga (KK)
        Route::prefix('kk')->group(function () {
            Route::get('/', [KkController::class, 'index'])->name('layanan.kk');
            Route::get('/baru', [KkBaruController::class, 'index'])->name('layanan.kk.baru');
            Route::get('/pisah', [KkPisahController::class, 'index'])->name('layanan.kk.pisah');
            Route::get('/hilang', [KkHilangController::class, 'index'])->name('layanan.kk.hilang');
            Route::get('/rusak', [KkRusakController::class, 'index'])->name('layanan.kk.rusak');
            Route::get('/ubah', [KkUbahController::class, 'index'])->name('layanan.kk.ubah');
            Route::get('/numpang', [KkNumpangController::class, 'index'])->name('layanan.kk.numpang');
        });

        // Grup Akta Kelahiran
        Route::prefix('akta-kelahiran')->group(function () {
            Route::get('/', [AktaController::class, 'index'])->name('layanan.akta');
            Route::get('/baru', [AktaBaruController::class, 'index'])->name('layanan.akta.baru');
            Route::get('/hilang', [AktaHilangController::class, 'index'])->name('layanan.akta.hilang');
            Route::get('/rusak', [AktaRusakController::class, 'index'])->name('layanan.akta.rusak');
            Route::get('/pembetulan', [AktaUbahController::class, 'index'])->name('layanan.akta.ubah');
        });    

        // Grup KIA
        Route::prefix('kia')->group(function () {
            Route::get('/', [KiaController::class, 'index'])->name('layanan.kia');
            Route::get('/baru', [KiaBaruController::class, 'index'])->name('layanan.kia.baru');
            Route::get('/hilang', [KiaHilangController::class, 'index'])->name('layanan.kia.hilang');
            Route::get('/rusak', [KiaRusakController::class, 'index'])->name('layanan.kia.rusak');
            Route::get('/alasan-lain', [KiaUbahController::class, 'index'])->name('layanan.kia.ubah');
        });

        // Grup Surat Pindah
        Route::prefix('pindah')->group(function () {
            Route::get('/', [PindahController::class, 'index'])->name('layanan.pindah');
            Route::get('/dalam-kota', [PindahDalamController::class, 'index'])->name('layanan.pindah.dalam');
            Route::get('/keluar-kota', [PindahKeluarController::class, 'index'])->name('layanan.pindah.keluar');
            Route::get('/datang-luar', [PindahDatangController::class, 'index'])->name('layanan.pindah.datang');
        });

        // Grup Akta Kematian
        Route::prefix('akta-kematian')->group(function () {
            Route::get('/', [AktaKematianController::class, 'index'])->name('layanan.kematian');
            Route::get('/baru', [KematianBaruController::class, 'index'])->name('layanan.kematian.baru');
            Route::get('/hilang', [KematianHilangController::class, 'index'])->name('layanan.kematian.hilang');
            Route::get('/rusak', [KematianRusakController::class, 'index'])->name('layanan.kematian.rusak');
            Route::get('/pembetulan', [KematianUbahController::class, 'index'])->name('layanan.kematian.ubah');
        });
    });
});

/*
|--------------------------------------------------------------------------
| 4. INSTANSI LAIN (Temporary)
|--------------------------------------------------------------------------
*/
Route::get('/dpmptsp', [HomeController::class, 'dpmptsp'])->name('dpmptsp');
Route::get('/diskominfo', [HomeController::class, 'diskominfo'])->name('diskominfo');
Route::get('/bpkpd', [HomeController::class, 'bpkpd'])->name('bpkpd');
Route::get('/dkp3', [HomeController::class, 'dkp3'])->name('dkp3');