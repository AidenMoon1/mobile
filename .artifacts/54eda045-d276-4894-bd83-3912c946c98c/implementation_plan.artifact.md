# Rencana Implementasi: Kembali Menggunakan MySQL (Mode Produksi)

Rencana ini bertujuan untuk memperbaiki masalah perizinan pada MySQL Kakak (Error 1130) dan mengalihkan kembali penyimpanan data (Cache & Session) dari file ke database MySQL agar aplikasi siap digunakan secara nyata.

## User Review Required

> [!CRITICAL]
> **Tindakan Penting**: Kita akan meriset hak akses database `root`. Ini akan memastikan Laravel diizinkan kembali untuk berbicara dengan MySQL.

---

## Langkah Perbaikan

### 1. Memperbaiki Izin MySQL (Fix Error 1130)
Saya akan mencoba memperbaiki tabel perizinan MariaDB agar mengizinkan koneksi dari `localhost` dan `127.0.0.1`.

### 2. Mengembalikan Setelan Laravel ke Database
Setelah database bisa diakses, saya akan mengubah kembali file `.env`:
- **`CACHE_STORE`**: Dari `file` kembali ke `database`.
- **`SESSION_DRIVER`**: Dari `file` kembali ke `database`.

### 3. Pembersihan Cache Sistem
Menjalankan `php artisan config:clear` agar Laravel benar-benar beralih menggunakan MySQL kembali.

---

## Perubahan yang Akan Dilakukan

#### [MODIFY] [.env](file:///C:/src/mobile/backend/.env)
- Mengembalikan `SESSION_DRIVER=database`
- Mengembalikan `CACHE_STORE=database`

---

## Rencana Verifikasi

### Manual Verification
1. **Tes Koneksi**: Menjalankan perintah `php artisan migrate:status`. Jika tidak muncul error merah, berarti MySQL sudah sembuh.
2. **Tes OTP**: Klik "Kirim Ulang Kode" di HP. Pastikan email tetap masuk dan kode tersimpan di tabel `cache` MySQL.
3. **Cek Dashboard**: Pastikan data berita dan pengaduan muncul dengan lancar.
