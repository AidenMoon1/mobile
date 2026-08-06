# Rencana Implementasi: Identitas Unik Per Perangkat

Tujuan dari rencana ini adalah untuk memastikan bahwa setiap HP yang menginstal aplikasi mendapatkan identitas (User ID) yang berbeda-beda secara otomatis. Dengan begitu, riwayat data tidak akan tertukar antar pengguna, meskipun semuanya tersimpan di satu database MySQL yang sama di laptop Bapak.

## User Review Required

> [!IMPORTANT]
> - Saya akan menghapus ID statis `ID-1003` yang ada sekarang.
> - Sebagai gantinya, aplikasi akan **membuat ID acak unik** (contoh: `SOA-882134`) saat pertama kali dibuka di HP baru.
> - ID ini akan disimpan permanen di memori HP tersebut, sehingga pengguna tersebut akan selalu menggunakan ID yang sama.

## Proposed Changes

### [Frontend/Flutter Layer]

#### [MODIFY] [user_service.dart](file:///C:/src/mobile/lib/services/user_service.dart)
- Mengubah logika inisialisasi profil.
- Jika data profil kosong (instalasi baru), aplikasi akan menjalankan fungsi `_generateUniqueId()`.
- Menghasilkan ID dengan format `SOA-` + 6 angka acak.

### [Backend/Laravel Layer]
- *Tidak ada perubahan kodingan*, karena API kita sudah pintar menyaring data berdasarkan `user_id` yang dikirim dari HP.

## Verification Plan

### Manual Verification
1.  **Hapus Data Aplikasi**: Coba hapus data aplikasi (Clear Storage) di HP Bapak untuk mensimulasikan instalasi baru.
2.  **Cek Profil**: Buka aplikasi, masuk ke menu Profil, dan pastikan ID yang muncul bukan lagi `ID-1003`, melainkan ID baru (misal `SOA-xxxxxx`).
3.  **Tes 2 Perangkat**: Kirim data dari HP Bapak, lalu kirim data dari Browser laptop.
4.  **Cek Database**: Buka phpMyAdmin, pastikan ada dua baris data dengan `user_id` yang berbeda.
5.  **Cek Riwayat**: Pastikan di HP Bapak hanya muncul data milik HP Bapak saja.
