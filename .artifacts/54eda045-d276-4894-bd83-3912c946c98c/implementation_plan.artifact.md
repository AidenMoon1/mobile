# Rencana Implementasi: Instansi OPD Real-Time Maintenance

Tujuan: Mengintegrasikan status pemeliharaan (Maintenance) pada Instansi OPD agar sinkron secara otomatis dan instan dengan pengaturan di Dashboard Admin.

## User Review Required

> [!IMPORTANT]
> **Otomatisasi Tampilan**: Instansi di Beranda Warga (Diskominfo, DPMPTSP, DKP3) dan di Daftar Instansi akan otomatis menjadi abu-abu dan tidak bisa diklik jika dinonaktifkan oleh Admin. Warga tidak perlu me-refresh halaman untuk melihat perubahan ini.

---

## Langkah Perbaikan

### 1. Sinkronisasi Dashboard Warga (Frontend)
- **[MODIFY] [dashboard_screen.dart](file:///C:/src/mobile/lib/views/berita_dan_fitur/dashboard_screen.dart)**:
    - Membungkus seksi "Instansi" dengan `ListenableBuilder` yang mendengarkan `OpdService`.
    - Memperbarui widget `_buildInstansiItem` agar menerima parameter `isMaintenance`.
    - Menerapkan efek visual `ColorFiltered` (Grayscale) dan label status pada item instansi yang tidak aktif.

### 2. Sinkronisasi Daftar Instansi (Frontend)
- **[MODIFY] [instansi_screen.dart](file:///C:/src/mobile/lib/views/instansi/instansi_screen.dart)**:
    - Memastikan list instansi mendengarkan perubahan status secara real-time.
    - Menambahkan indikator visual "Maintenance" pada list item jika instansi dinonaktifkan.

### 3. Keamanan Navigasi
- Menambahkan pengecekan status instansi sebelum berpindah halaman profil dinas. Jika instansi sedang maintenance, warga akan diarahkan ke `MaintenanceScreen`.

---

## Rencana Verifikasi

### Manual Verification
1. **Tes Real-Time**: Buka Dashboard Warga di HP. Di laptop Admin (menu Profil Instansi), matikan instansi **"DISKOMINFO"**.
2. **Cek Respon**: Pastikan item "Diskominfo" di HP langsung berubah warna menjadi abu-abu dalam hitungan detik.
3. **Tes Klik**: Coba klik instansi yang sedang maintenance, pastikan yang muncul adalah halaman pengumuman pemeliharaan sistem.
