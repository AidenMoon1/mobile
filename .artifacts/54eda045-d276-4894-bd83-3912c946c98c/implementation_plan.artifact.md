# Rencana Implementasi Keamanan (Security Hardening Roadmap)

Dokumen ini merinci langkah-langkah teknis untuk mengubah sistem "Simulasi" saat ini menjadi sistem "Produksi" yang aman dan siap pakai untuk warga Sukabumi.

## User Review Required

> [!IMPORTANT]
> - **Transisi ke JWT/Sanctum**: Kita akan mengganti sistem `user_id` manual dengan Token Keamanan Digital.
> - **Integrasi Gateway**: Memerlukan akun layanan pihak ketiga (seperti Fonnte atau Twilio) untuk WhatsApp OTP nyata.
> - **Sertifikat SSL**: Wajib dipasang saat project dipindahkan ke server pemerintah.

---

## 1. Tahap 1: Autentikasi API yang Aman (Mencegah Pencurian Data)

### Masalah Saat Ini:
Identitas pengguna (`ID-1003`) dikirim dalam teks biasa. Siapapun bisa mengubah ID tersebut untuk melihat data orang lain.

### Solusi: Laravel Sanctum (Token-Based Auth)
1.  **Backend (Laravel)**:
    - Install Laravel Sanctum: `composer require laravel/sanctum`.
    - Buat sistem "Login" yang memberikan **Access Token**.
    - Pasang Middleware `auth:sanctum` pada seluruh route API (Aduan, Feedback, Profil).
2.  **Frontend (Flutter)**:
    - Simpan Token di memori aman (`flutter_secure_storage`).
    - Kirim Token dalam Header: `Authorization: Bearer <token_rahasia>`.

---

## 2. Tahap 2: WhatsApp OTP Nyata (Mengamankan Gerbang Masuk)

### Masalah Saat Ini:
User bisa login hanya dengan mengetik 6 angka sembarang.

### Solusi: Integrasi WhatsApp Gateway
1.  **Backend (Laravel)**:
    - Hubungkan Laravel ke API Gateway (misal: Fonnte).
    - Simpan kode OTP di **Redis/Cache** dengan waktu kedaluwarsa 5 menit.
    - Hanya berikan Token Akses jika user memasukkan kode yang benar-benar dikirim ke nomor WA-nya.
2.  **Frontend (Flutter)**:
    - Tambahkan fitur "Kirim Ulang OTP" jika pesan tidak kunjung sampai.
    - Implementasikan **Auto-Fill OTP** agar user tidak perlu mengetik manual.

---

## 3. Tahap 3: Enkripsi Jalur Data (Mencegah Penyadapan)

### Masalah Saat Ini:
Aplikasi masih mengizinkan koneksi `http://` yang tidak aman.

### Solusi: HTTPS & Security Manifest
1.  **Server**:
    - Pasang Sertifikat SSL (Let's Encrypt).
2.  **Android Config**:
    - Ubah `android:usesCleartextTraffic` menjadi **`false`**.
    - Gunakan **Network Security Configuration** untuk membatasi koneksi hanya ke domain resmi Sukabumi (`*.sukabumikota.go.id`).

---

## Ringkasan Perubahan Teknis

### [MODIFY] [api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)
- Penambahan penanganan token otomatis pada setiap permintaan API.

### [MODIFY] [OtpApiController.php](file:///C:/src/mobile/backend/app/Http/Controllers/Api/OtpApiController.php)
- Penggantian logika simulasi dengan pemanggilan API Gateway nyata.

---

## Verification Plan

### Automated Tests
- Tes penetrasi sederhana: Mencoba mengakses data ID orang lain tanpa token yang sah (harus ditolak server dengan error 401).

### Manual Verification
- Verifikasi bahwa pesan WhatsApp benar-benar masuk ke HP saat mencoba login.
- Verifikasi aplikasi menolak koneksi jika server tidak menggunakan `https`.
