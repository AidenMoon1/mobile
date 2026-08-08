<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Log;

class EmailOtpController extends Controller
{
    /**
     * Generate and send OTP to user email.
     */
    public function sendOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $email = $request->email;
        $otp = rand(100000, 999999);

        // Store OTP in cache for 5 minutes
        Cache::put('otp_' . $email, $otp, 300);

        // Log the OTP
        Log::info("OTP Code for $email: $otp");

        // Send real email
        Mail::raw("Kode verifikasi Sukabumi One Access Anda adalah: $otp. Berlaku selama 5 menit.", function ($message) use ($email) {
            $message->to($email)->subject('Kode Verifikasi Sukabumi One Access');
        });

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
