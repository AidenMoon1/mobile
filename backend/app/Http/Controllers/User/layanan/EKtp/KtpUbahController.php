<?php

namespace App\Http\Controllers\User\layanan\EKtp;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\KtpUbah; // Pastikan Model ini sudah dibuat
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class KtpUbahController extends Controller
{
    /**
     * Menampilkan Halaman Form Perubahan Data KTP
     */
    public function index()
    {
        return view('pages.user.dukcapil.layanan.ktp.ubah');
    }

    /**
     * Menyimpan Data Pengajuan ke Database
     */
    public function store(Request $request)
    {
        // 1. Validasi Input
        $request->validate([
            'nama'            => 'required|string|max:255',
            'nik'             => 'required|digits:16',
            'no_kk'           => 'required|digits:16',
            'email'           => 'required|email',
            'phone'           => 'required|string',
            'jenis_perubahan' => 'required|string',
            'provinsi_name'   => 'required|string',
            'kota_name'       => 'required|string',
            'kecamatan_name'  => 'required|string',
            'kelurahan_name'  => 'required|string',
            'alamat_lengkap'  => 'required|string',
            'rt'              => 'required|string|max:5', // Diganti ke string agar nol tidak hilang
            'rw'              => 'required|string|max:5', // Diganti ke string
            // File 1: KK Baru (Wajib)
            'file_kk_baru'    => 'required|image|mimes:jpeg,png,jpg|max:2048', 
            // File 2: Pendukung (Opsional)
            'file_pendukung'  => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ], [
            'nik.digits'            => 'NIK harus tepat 16 digit.',
            'no_kk.digits'          => 'Nomor KK harus tepat 16 digit.',
            'file_kk_baru.required' => 'Foto Kartu Keluarga Baru wajib diunggah.',
            'file_kk_baru.max'      => 'Ukuran file maksimal 2MB.',
        ]);

        try {
            /** @var \App\Models\User $user */
            $user = Auth::user();

            // 2. Proses Upload Berkas
            // Simpan ke: storage/app/public/berkas/ktp_ubah/
            $pathKk = $request->file('file_kk_baru')->store('berkas/ktp_ubah/kk', 'public');
            
            $pathPendukung = null;
            if ($request->hasFile('file_pendukung')) {
                $pathPendukung = $request->file('file_pendukung')->store('berkas/ktp_ubah/pendukung', 'public');
            }

            // 3. Simpan Data ke Database
            KtpUbah::create([
                'user_id'         => $user->id, // ID Akun warga yang login
                'nama'            => $request->nama,
                'nik'             => $request->nik,
                'no_kk'           => $request->no_kk,
                'email'           => $request->email,
                'phone'           => $request->phone,
                'jenis_perubahan' => $request->jenis_perubahan,
                'provinsi'        => $request->provinsi_name,
                'kota'            => $request->kota_name,
                'kecamatan'       => $request->kecamatan_name,
                'kelurahan'       => $request->kelurahan_name,
                'alamat_lengkap'  => $request->alamat_lengkap,
                'rt'              => $request->rt,
                'rw'              => $request->rw,
                'file_kk_baru'    => $pathKk,
                'file_pendukung'  => $pathPendukung,
                'status'          => 'Menunggu Verifikasi',
            ]);

            // 4. Redirect ke Home dengan pesan sukses
            return redirect()->route('home')->with('success', 'Permohonan Perubahan Data KTP berhasil dikirim!');

        } catch (\Exception $e) {
            // Jika ada error sistem (database/storage)
            return back()->with('error', 'Terjadi kesalahan: ' . $e->getMessage())->withInput();
        }
    }
}