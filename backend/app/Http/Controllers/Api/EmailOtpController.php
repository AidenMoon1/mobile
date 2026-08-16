<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Log;

use App\Models\User;
use App\Mail\AdminOTPMail;
use Illuminate\Support\Facades\Hash;

class EmailOtpController extends Controller
{
    /**
     * Generate and send OTP to user email.
     */
    public function sendOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'nullable|string', // Required for admin type
            'type' => 'nullable|string', // 'admin' or 'user'
        ]);

        $email = $request->email;

        // Cek Role & Password jika ini adalah request dari Login Admin
        if ($request->type === 'admin') {
            $user = User::where('email', $email)->first();

            // 1. Cek keberadaan user & password
            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Kredensial tidak valid.'
                ], 401);
            }

            // 2. Cek Role (Hanya Super Admin & Admin Dinas)
            if (!in_array($user->role, ['super_admin', 'admin_dinas'])) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Anda tidak memiliki otoritas akses administrator.'
                ], 403);
            }
        }

        // Cek ketersediaan email jika ini adalah request pendaftaran baru
        if ($request->type === 'registration') {
            $existingUser = User::where('email', $email)->first();
            if ($existingUser) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Alamat email ini sudah terdaftar. Silakan gunakan menu Masuk.'
                ], 409);
            }
        }

        $otp = rand(100000, 999999);

        // Tentukan Judul dan Isi Pesan Email berdasarkan tipe
        $title = 'Verifikasi Akun Warga';
        $messageBody = 'Silakan masukkan kode OTP berikut untuk melanjutkan akses ke Portal Layanan Publik.';

        if ($request->type === 'admin') {
            $title = 'Verifikasi Administrator';
            $messageBody = 'Silakan gunakan kode OTP di bawah ini untuk memverifikasi identitas Anda dan melanjutkan akses ke Command Center.';
        } elseif ($request->type === 'registration') {
            $title = 'Aktivasi Akun Warga';
            $messageBody = 'Permintaan pendaftaran akun baru telah diterima. Silakan masukkan kode OTP berikut untuk mengaktifkan identitas digital Anda.';
        }

        // Store OTP in cache for 5 minutes
        Cache::put('otp_' . $email, $otp, 300);

        // Log the OTP
        Log::info("OTP Code for $email: $otp");

        // Send real email using the fancy template
        try {
            Mail::to($email)->send(new AdminOTPMail($otp, $title, $messageBody));
        } catch (\Exception $e) {
            Log::error("Failed to send OTP email: " . $e->getMessage());
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Kode OTP telah dikirim ke email ' . $email,
        ]);
    }

    /**
     * Verify the provided OTP.
     */
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'otp' => 'required|string|size:6',
        ]);

        $storedOtp = Cache::get('otp_' . $request->email);

        if (!$storedOtp) {
            return response()->json([
                'status' => 'error',
                'message' => 'Kode OTP kedaluwarsa atau tidak ditemukan.'
            ], 400);
        }

        if ($request->otp == $storedOtp) {
            Cache::forget('otp_' . $request->email);
            return response()->json([
                'status' => 'success',
                'message' => 'Verifikasi berhasil.'
            ]);
        }

        return response()->json([
            'status' => 'error',
            'message' => 'Kode OTP yang Anda masukkan salah.'
        ], 400);
    }
}
