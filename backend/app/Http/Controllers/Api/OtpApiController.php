<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class OtpApiController extends Controller
{
    /**
     * Simulation of sending OTP via WhatsApp Gateway.
     */
    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|string|min:10',
        ]);

        $otp = rand(100000, 999999);
        $phone = $request->phone;

        // In production, you would call a gateway like Fonnte/Twilio here
        Log::info("Sending OTP $otp to $phone via WhatsApp.");

        return response()->json([
            'status' => 'success',
            'message' => 'OTP has been sent to ' . $phone,
            'simulated_otp' => $otp // Return for dev testing
        ]);
    }

    /**
     * Verify the OTP code.
     */
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
            'otp' => 'required|string|size:6',
        ]);

        // Validation logic here...

        return response()->json([
            'status' => 'success',
            'message' => 'Login successful',
            'token' => 'simulated-jwt-token-for-' . $request->phone
        ]);
    }
}
