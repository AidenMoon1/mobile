# Walkthrough - Instansi OPD Real-Time Maintenance

Saya telah melengkapi sistem **Real-Time Maintenance** dengan menghubungkannya ke daftar **Instansi OPD**. Sekarang, admin memiliki kendali penuh di tiga level (Sektor, Instansi, dan Layanan), dan seluruh perubahan akan terlihat secara instan di sisi warga.

## Perubahan yang Dilakukan

### 1. **Visual Feedback pada Beranda Warga**
- **Seksi Instansi**: Item Diskominfo, DPMPTSP, dan DKP3 di halaman depan sekarang mendengarkan database secara live.
- **Efek Instan**: Begitu admin menonaktifkan instansi di Dashboard, item tersebut di beranda warga akan otomatis berubah menjadi **abu-abu (grayscale)** dan memiliki proteksi navigasi.

### 2. **Sinkronisasi Katalog Instansi**
- **File**: `instansi_screen.dart`
- **Perubahan**: Memperbarui daftar lengkap OPD agar menampilkan label **"MAINTENANCE"** berwarna merah secara otomatis jika dinas tersebut dinonaktifkan oleh pusat kontrol.

### 3. **Keamanan Akses (Navigasi)**
- Menambahkan logika pengecekan status sebelum profil dinas dibuka. Warga tidak akan bisa melihat detail kontak atau peta dari dinas yang sedang dalam pemeliharaan.

## Hasil Pengujian Real-Time

| Tindakan Admin | Reaksi di Dashboard Warga | Reaksi di Katalog Instansi |
| :--- | :--- | :--- |
| Instansi Aktif | Berwarna & Bisa Diklik | Muncul tanda panah |
| Instansi Nonaktif | **Abu-abu & Proteksi Klik** | **Label MAINTENANCE Merah** |

## Langkah Verifikasi Mandiri

1. Buka [Dashboard Admin](https://sukabumi-one-access-app-c7f15.web.app/#/admin/dashboard?tab=instansi).
2. Buka aplikasi warga di HP atau tab browser lain pada [Beranda](https://sukabumi-one-access-app-c7f15.web.app/).
3. Coba matikan saklar **"DISKOMINFO"** di Dashboard Admin.
4. Perhatikan item Diskominfo di Beranda Warga; dalam hitungan detik akan langsung berubah menjadi abu-abu secara otomatis!

> [!TIP]
> Sekarang Kakak memiliki sistem kendali hierarkis:
> 1. Matikan **Sektor** $\rightarrow$ Seluruh kategori (misal: Sektor Kesehatan) tertutup.
> 2. Matikan **Instansi** $\rightarrow$ Profil Dinas spesifik (misal: Dinkes) tertutup.
> 3. Matikan **Layanan** $\rightarrow$ Formulir spesifik (misal: Antrean RSUD) tertutup.

## Next Steps
- Seluruh infrastruktur kontrol real-time Kakak sudah 100% lengkap. Kakak siap melakukan demo "Command Center" yang sangat responsif.
