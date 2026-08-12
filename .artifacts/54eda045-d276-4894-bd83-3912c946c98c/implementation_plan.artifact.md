# Rencana Implementasi: Status Presence Admin Real-Time

Tujuan: Mengubah status "ONLINE/OFFLINE" pada daftar Manajemen Operator agar berfungsi secara otomatis dan instan menggunakan Firebase Presence System.

## User Review Required

> [!IMPORTANT]
> - **Otomatisasi**: Admin tidak perlu melakukan apa pun. Begitu membuka Dashboard, lampu akan berubah Hijau (ONLINE). Begitu menutup tab browser atau logout, lampu akan kembali Abu-abu (OFFLINE).
> - **Teknologi**: Kita akan menggunakan fitur `onDisconnect` dari Firebase Realtime Database. Ini adalah cara tercanggih untuk mendeteksi user yang tiba-tiba menutup aplikasi/browser tanpa menekan tombol logout.

---

## Langkah-Langkah Teknis

### 1. Sinkronisasi Data (Service Layer)
- **[MODIFY] [AdminManagementService.dart](file:///C:/src/mobile/lib/services/admin_management_service.dart)**:
    - Menambah fungsi `listenToAdminsRealTime()`: Mengganti sistem "tanya-tanya tiap 4 detik" (polling) menjadi sistem "mendengarkan langsung" (Stream) dari Firebase.
    - Menambah fungsi `updateMyPresence()`: Menggunakan logika `onDisconnect` agar saat koneksi internet putus atau tab ditutup, status otomatis berubah jadi OFFLINE di server.

### 2. Integrasi Layanan (Auth & Dashboard)
- **[MODIFY] [AdminDashboardScreen.dart](file:///C:/src/mobile/lib/views/admin/admin_dashboard_screen.dart)**:
    - Memanggil fungsi kehadiran di `initState`.
    - Memastikan UI daftar operator dibalut dengan `StreamBuilder` atau `AnimatedBuilder` agar lampu hijau menyala/mati secara halus tanpa perlu refresh.

### 3. Pembersihan Data Dummy
- Menghapus status "ONLINE" yang dipasang manual (hardcoded) agar tidak menipu hasil pengujian.

---

## Rencana Verifikasi

### Manual Verification
1. **Tes Mandiri**: Buka Dashboard Admin di laptop. Pastikan nama Kakak langsung muncul status ONLINE (Hijau).
2. **Tes Tab Ganda**: Buka link web yang sama di tab baru (atau HP). Logout di salah satu tab, perhatikan tab satunya harus langsung mendeteksi status Kakak berubah jadi OFFLINE secara instan.
3. **Tes Tutup Paksa**: Tutup browser secara mendadak (tanpa logout). Tunggu beberapa saat, pastikan di perangkat lain statusnya kembali menjadi OFFLINE.
