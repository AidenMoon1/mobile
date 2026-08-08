# Rencana Implementasi: Aktivasi Real Gmail OTP

Tujuan dari rencana ini adalah menghubungkan Laravel ke server SMTP Gmail agar kode verifikasi 6 digit benar-benar masuk ke kotak masuk (Inbox) email warga secara otomatis.

## User Review Required

> [!CAUTION]
> **Tindakan Wajib Kakak (Keamanan Google):**
> Gmail tidak mengizinkan aplikasi asing mengirim email menggunakan password Gmail biasa. Kakak **HARUS** membuat **App Password** 16 karakter.
>
> **Cara Membuatnya:**
> 1. Buka [Google Account Security](https://myaccount.google.com/security).
> 2. Pastikan **2-Step Verification** sudah AKTIF.
> 3. Klik menu **App passwords**.
> 4. Ketik nama bebas (contoh: "Laravel Sukabumi") lalu klik **Create**.
> 5. **Salin 16 karakter** yang muncul di kotak kuning. Masukkan kode tersebut nanti saat saya minta.

---

## Perubahan yang Akan Dilakukan

### 1. Backend (Laravel) - Aktivasi SMTP
- **[MODIFY] [.env](file:///C:/src/mobile/backend/.env)**:
    - Mengubah `MAIL_MAILER` dari `log` menjadi `smtp`.
    - Mengatur host ke `smtp.gmail.com` dan port `465` (SSL).
    - Menyiapkan kolom `MAIL_USERNAME` dan `MAIL_PASSWORD` untuk diisi data Kakak.
- **[MODIFY] [EmailOtpController.php](file:///C:/src/mobile/backend/app/Http/Controllers/Api/EmailOtpController.php)**:
    - Mengaktifkan fungsi `Mail::raw()` yang sebelumnya saya beri tanda komentar (`//`).

---

## Rencana Verifikasi

### Manual Verification
1. **Input Kredensial**: Kakak memasukkan email dan 16 digit App Password ke file `.env`.
2. **Kirim OTP**: Buka aplikasi di HP, masukkan email asli Kakak, klik "Kirim OTP".
3. **Cek Inbox**: Buka Gmail Kakak di perangkat apa pun. Pastikan ada pesan baru dari "Sukabumi One Access" berisi 6 digit angka.
4. **Verifikasi**: Masukkan angka tersebut di HP untuk memastikan login berhasil 100%.
