<?php

namespace App\Http\Controllers\User\layanan\EKtp;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\KtpRusak; 
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class KtpRusakController extends Controller
{
    /**
     * Menampilkan Halaman Form KTP Rusak
     */
    public function index()
    {
        return view('pages.user.dukcapil.layanan.ktp.rusak');
    }

    /**
     * Menyimpan Data Pengajuan ke Database
     */
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
            'phone'           => 'required|string|max:20',
            'provinsi_name'   => 'required|string',
            'kota_name'       => 'required|string',
            'kecamatan_name'  => 'required|string',
            'kelurahan_name'  => 'required|string',
            'alamat_lengkap'  => 'required|string',
            'rt'              => 'required|string|max:5', // Diganti ke string agar nol tidak hilang
            'rw'              => 'required|string|max:5', // Diganti ke string
            'file_rusak'      => 'required|image|mimes:jpeg,png,jpg|max:2048', 
            'file_kk'         => 'required|image|mimes:jpeg,png,jpg|max:2048',
        ], [
            'nik.digits'            => 'NIK harus tepat 16 digit.',
            'no_kk.digits'          => 'Nomor KK harus tepat 16 digit.',
            'file_rusak.required'   => 'Foto KTP yang rusak wajib diunggah.',
            'file_rusak.image'      => 'Berkas harus berupa gambar (JPG/PNG).',
            'file_rusak.max'        => 'Ukuran foto maksimal 2MB.',
            'file_kk.required'      => 'Foto Kartu Keluarga wajib diunggah.',
        ]);

        try {
            // 2. Proses Upload Berkas ke Storage
            // File akan masuk ke: storage/app/public/berkas/ktp_rusak/
            $pathRusak = $request->file('file_rusak')->store('berkas/ktp_rusak', 'public');
            $pathKk    = $request->file('file_kk')->store('berkas/kk_ktp_rusak', 'public');

            // 3. Simpan Data ke Tabel ktp_rusaks
            KtpRusak::create([
                'user_id'         => $user->id, 
                'nama'            => $request->nama,
                'nik'             => $request->nik,
                'no_kk'           => $request->no_kk,
                'email'           => $request->email,
                'phone'           => $request->phone,
                'keterangan'      => $request->keterangan,
                'provinsi'        => $request->provinsi_name, // Mengambil teks nama wilayah
                'kota'            => $request->kota_name,
                'kecamatan'       => $request->kecamatan_name,
                'kelurahan'       => $request->kelurahan_name,
                'alamat_lengkap'  => $request->alamat_lengkap,
                'rt'              => $request->rt,
                'rw'              => $request->rw,
                'file_rusak'      => $pathRusak,
                'file_kk'         => $pathKk,
                'status'          => 'Menunggu Verifikasi',
            ]);

            // 4. Redirect ke Home dengan pesan sukses untuk SweetAlert
            return redirect()->route('home')->with('success', 'Permohonan KTP Rusak Anda berhasil dikirim! Admin akan segera memproses laporan Anda.');

        } catch (\Exception $e) {
            // Jika ada kegagalan teknis (database/server)
            return back()->with('error', 'Terjadi kesalahan sistem saat menyimpan data.')->withInput();
        }
    }
}