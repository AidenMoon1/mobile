<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class AdminApiController extends Controller
{
    /**
     * Store a newly created admin user in the database.
     */
    public function storeAdmin(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'username' => 'required|string|unique:users,username',
                'email' => 'required|email|unique:users,email',
                'phone' => 'nullable|string',
                'password' => 'required|string|min:6',
                'role' => 'required|string', // super_admin or admin_dinas
            ]);

            $user = User::create([
                'name' => $validated['name'],
                'username' => $validated['username'],
                'email' => $validated['email'],
                'phone' => $validated['phone'] ?? '-',
                'password' => Hash::make($validated['password']),
                'role' => $validated['role'],
                'email_verified_at' => now(), // Auto-verify for admins added by other admins
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Administrator ' . $user->name . ' berhasil didaftarkan di database.',
                'data' => $user
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal: ' . implode(', ', collect($e->errors())->flatten()->toArray())
            ], 422);
        } catch (\Exception $e) {
            Log::error("Admin Registration Error: " . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan sistem: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete an admin user from the database.
     */
    public function destroyAdmin(Request $request)
    {
        try {
            $email = $request->query('email');

            if (!$email) {
                return response()->json(['status' => 'error', 'message' => 'Email wajib disertakan.'], 400);
            }

            $user = User::where('email', $email)->first();

            if (!$user) {
                return response()->json(['status' => 'error', 'message' => 'Administrator tidak ditemukan di database.'], 404);
            }

            // Mencegah penghapusan superadmin utama (Proteksi sistem)
            if ($user->username === 'superadmin') {
                 return response()->json(['status' => 'error', 'message' => 'Superadmin utama tidak dapat dihapus.'], 403);
            }

            $user->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Administrator ' . $email . ' berhasil dihapus dari database.'
            ]);

        } catch (\Exception $e) {
            return response()->json(['status' => 'error', 'message' => 'Gagal menghapus: ' . $e->getMessage()], 500);
        }
    }
}
