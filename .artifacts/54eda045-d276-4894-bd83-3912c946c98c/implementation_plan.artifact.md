# Rencana Perbaikan: Pembersihan Duplikasi UI Login

Tujuan dari rencana ini adalah untuk merapikan tampilan layar Login yang berantakan setelah proses `git pull`, khususnya menghapus tombol "Lupa Kata Sandi" yang muncul dua kali.

## User Review Required

> [!NOTE]
> - Saya hanya akan menghapus kode yang duplikat.
> - Fitur login Google tetap dipertahankan, namun pesan error pada gambar menunjukkan kendala koneksi atau konfigurasi Firebase yang perlu dicek jika login Google gagal.

## Perubahan yang Akan Dilakukan

### [Frontend/Flutter]

#### [MODIFY] [login_screen.dart](file:///C:/src/mobile/lib/views/profile/login_screen.dart)
- Menghapus blok kode "Lupa Kata Sandi" yang kedua (yang terletak di bawah link pendaftaran).
- Memastikan tata letak tombol login dan SSO tetap simetris.

## Rencana Verifikasi

### Manual Verification
1. **Buka Layar Login**: Pastikan hanya ada satu tombol "Lupa Kata Sandi" di bawah kolom Password.
2. **Cek Alur**: Pastikan tombol "Masuk Akun", "Google", dan "SSO" tetap berfungsi dan memiliki jarak yang rapi.
