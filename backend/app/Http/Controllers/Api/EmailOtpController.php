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
            'type' => 'nullable|string', // 'admin' or 'user'
        ]);

        $email = $request->email;

        // Cek Role jika ini adalah request dari Login Admin
        if ($request->type === 'admin') {
            $user = User::where('email', $email)->first();
            if (!$user || !in_array($user->role, ['super_admin', 'admin_dinas'])) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Anda tidak memiliki otoritas akses administrator.'
                ], 403);
            }
        }

        $otp = rand(100000, 999999);

        // Store OTP in cache for 5 minutes
        Cache::put('otp_' . $email, $otp, 300);

        // Log the OTP
        Log::info("OTP Code for $email: $otp");

        // Send real email using the styled template from web team
        try {
            Mail::to($email)->send(new AdminOTPMail($otp));
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
