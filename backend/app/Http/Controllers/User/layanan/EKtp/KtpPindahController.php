<?php

namespace App\Http\Controllers\User\layanan\EKtp;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\KtpPindah; // Import Model
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class KtpPindahController extends Controller
{
    /**
     * Menampilkan Halaman Form KTP Pindah Domisili
     */
    public function index()
    {
        return view('pages.user.dukcapil.layanan.ktp.pindah');
    }

    /**
     * Menyimpan Data Pengajuan ke Database
     */
    public function store(Request $request)
    {
        // 1. Validasi Input (Sudah ditambahkan RT & RW)
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
            'rt'              => 'required|string|max:5', // Diganti ke string agar nol tidak hilang
            'rw'              => 'required|string|max:5', // Diganti ke string
            'file_skpwni'     => 'required|image|mimes:jpeg,png,jpg|max:2048', // Max 2MB
            'file_kk'         => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ], [
            'nik.digits'      => 'NIK harus tepat 16 digit.',
            'no_kk.digits'    => 'Nomor KK harus tepat 16 digit.',
            'rt.required'     => 'RT wajib diisi.',
            'rw.required'     => 'RW wajib diisi.',
            'file_skpwni.required' => 'Foto KK Baru/SKPWNI wajib diunggah.',
            'file_skpwni.max' => 'Ukuran file maksimal 2MB.',
        ]);

        try {
            /** @var \App\Models\User $user */
            $user = Auth::user();

            // 2. Proses Upload Berkas
            // Disimpan di folder: storage/app/public/berkas/ktp_pindah
            $pathSkpwni = $request->file('file_skpwni')->store('berkas/ktp_pindah', 'public');
            
            $pathPendukung = null;
            if ($request->hasFile('file_kk')) {
                $pathPendukung = $request->file('file_kk')->store('berkas/ktp_pindah/pendukung', 'public');
            }

            // 3. Simpan ke Database
            KtpPindah::create([
                'user_id'         => $user->id,
                'nama'            => $request->nama,
                'nik'             => $request->nik,
                'no_kk'           => $request->no_kk,
                'email'           => $request->email,
                'phone'           => $request->phone,
                'keterangan'      => $request->keterangan,
                'provinsi'        => $request->provinsi_name,
                'kota'            => $request->kota_name,
                'kecamatan'       => $request->kecamatan_name,
                'kelurahan'       => $request->kelurahan_name,
                'alamat_lengkap'  => $request->alamat_lengkap,
                'rt'              => $request->rt, // MENYIMPAN RT
                'rw'              => $request->rw, // MENYIMPAN RW
                'file_skpwni'     => $pathSkpwni,
                'file_pendukung'  => $pathPendukung,
                'status'          => 'Menunggu Verifikasi',
            ]);

            // 4. Redirect dengan SweetAlert (Success)
            return redirect()->route('home')->with('success', 'Permohonan Pindah Domisili berhasil dikirim!');

        } catch (\Exception $e) {
            // Jika ada error (misal database diskonek atau kolom kurang)
            return back()->with('error', 'Terjadi kesalahan sistem: ' . $e->getMessage())->withInput();
        }
    }
}