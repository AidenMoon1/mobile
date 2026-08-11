<?php

namespace App\Http\Controllers\User\layanan\EKtp;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\KtpHilang; 
use Illuminate\Support\Facades\Auth; 
use Illuminate\Support\Facades\Storage;

class KtpHilangController extends Controller
{
    public function index() {
        return view('pages.user.dukcapil.layanan.ktp.hilang');
    }

    public function store(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = Auth::user();

        // 1. Validasi Input
        $request->validate([
            'nama'            => 'required|string|max:255',
            'nik'             => 'required|digits:16',
            'no_kk'           => 'required|digits:16',
            'email'           => 'required|email',
            'phone'           => 'required|string',
            'provinsi_name'   => 'required|string',
            'kota_name'       => 'required|string',
            'kecamatan_name'  => 'required|string',
            'kelurahan_name'  => 'required|string',
            'alamat_lengkap'  => 'required|string',
            'rt'              => 'required|string|max:5',
            'rw'              => 'required|string|max:5',
            'file_kehilangan' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            'file_kk'         => 'required|image|mimes:jpeg,png,jpg|max:2048',
        ], [
            'nik.digits'   => 'NIK harus 16 digit.',
            'no_kk.digits' => 'Nomor KK harus 16 digit.',
            'file_kehilangan.required' => 'Surat kehilangan wajib diunggah.',
            'file_kk.required' => 'Foto Kartu Keluarga wajib diunggah.'
        ]);

        try {
            // 2. Simpan File ke Storage (Public)
            $pathKehilangan = $request->file('file_kehilangan')->store('berkas/ktp_hilang', 'public');
            $pathKk = $request->file('file_kk')->store('berkas/kk_ktp_hilang', 'public');

            // 3. Simpan ke Database
            KtpHilang::create([
                'user_id'         => $user->id, 
                'nama'            => $request->nama,
                'nik'             => $request->nik,
                'no_kk'           => $request->no_kk,
                'email'           => $request->email,
                'phone'           => $request->phone,
                'keterangan'      => $request->keterangan,
                'provinsi'        => $request->provinsi_name, // Mengambil teks Nama
                'kota'            => $request->kota_name,
                'kecamatan'       => $request->kecamatan_name,
                'kelurahan'       => $request->kelurahan_name,
                'alamat_lengkap'  => $request->alamat_lengkap,
                'rt'              => $request->rt,
                'rw'              => $request->rw,
                'file_kehilangan' => $pathKehilangan,
                'file_kk'         => $pathKk,
                'status'          => 'Menunggu Verifikasi',
            ]);

            // 4. Redirect dengan pesan sukses
            return redirect()->route('home')->with('success', 'Laporan KTP Hilang berhasil dikirim! Admin akan segera memproses.');

        } catch (\Exception $e) {
            return back()->with('error', 'Gagal menyimpan data: ' . $e->getMessage())->withInput();
        }
    }
}