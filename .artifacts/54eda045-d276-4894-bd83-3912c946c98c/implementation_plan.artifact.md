# Rencana Perbaikan: Dashboard Admin Gray Screen (Post-Merge Fix)

Tujuan: Memperbaiki crash (layar abu-abu) pada Dashboard Admin yang terjadi setelah proses pull, dengan meningkatkan keamanan null-safety dan sinkronisasi identitas admin.

## User Review Required

> [!CRITICAL]
> **Identitas Admin**: Saya akan menambahkan email Kakak (`sakalangit112@gmail.com`) ke dalam daftar operator permanen di kodingan. Ini kunci utama agar aplikasi mengenali siapa yang sedang login.

---

## Langkah Perbaikan

### 1. Sinkronisasi Identitas Admin (Service Layer)
- **[MODIFY] [admin_management_service.dart](file:///C:/src/mobile/lib/services/admin_management_service.dart)**:
    - Mendaftarkan email Kakak di daftar `_initDefaultAdmins`.
    - Menghapus paksaan `isOnline: true` yang bisa bikin crash saat database cloud belum siap.

### 2. Penguatan Null-Safety (Frontend)
- **[MODIFY] [admin_dashboard_screen.dart](file:///C:/src/mobile/lib/views/admin/admin_dashboard_screen.dart)**:
    - Memberikan nilai default (`?? '-'`) pada data-data yang ditarik dari database agar tidak terjadi error "Null check operator".
    - Membungkus proses inisialisasi kehadiran dengan penanganan error yang lebih baik.

### 3. Deploy Update
Setelah kodingan diperbaiki, kita lakukan build web dan deploy ulang ke Firebase Hosting.

---

## Rencana Verifikasi

### Manual Verification
1. **Login Ulang**: Masuk sebagai Admin pakai email Kakak.
2. **Cek Dashboard**: Pastikan tidak ada lagi layar abu-abu, melainkan muncul statistik "Total Instansi" dan "Total Layanan".
3. **Cek Menu**: Klik menu "Kelola Pengguna", pastikan daftar warga muncul tanpa error.
