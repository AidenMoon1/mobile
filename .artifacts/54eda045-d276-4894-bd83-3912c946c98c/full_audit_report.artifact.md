# Laporan Audit Lengkap: Sukabumi One Access
**Tanggal Audit:** 6 Agustus 2026
**Status Project:** Pengembangan Aktif (Simulasi)
**Tujuan Audit:** Mengevaluasi arsitektur, fitur, keamanan, dan kesiapan infrastruktur.

---

## 1. Ringkasan Arsitektur

Project ini menggunakan arsitektur **Client-Server** yang modern:
- **Frontend:** Flutter (v3.44.6) - Mendukung Android, iOS, dan Web Browser.
- **Backend:** Laravel (v13.8) - Berfungsi sebagai REST API pusat.
- **Database:**
  - **MySQL** (Server Pusat): Penyimpanan utama data warga, pengaduan, dan layanan.
  - **SQLite** (Local HP): Cache notifikasi dan feedback offline (khusus versi HP).
  - **Firebase Cloud Firestore**: Digunakan untuk fitur Live Chat real-time.

---

## 2. Analisis Fitur Utama

| Fitur | Deskripsi | Status |
| :--- | :--- | :--- |
| **Pusat Pengaduan** | Form input keluhan warga dengan kategori dan riwayat. | **Aktif (Real DB)** |
| **Kritik & Saran** | Penilaian 5 bintang (gold) dengan kategori faktor kepuasan. | **Aktif (Real DB)** |
| **Notifikasi** | Sistem pesan terpusat dengan filter kategori (Layanan, Kebencanaan). | **Aktif (Real DB)** |
| **Live Chat** | Obrolan langsung dengan admin atau AI Bot SOA via Firebase. | **Aktif (Firebase)** |
| **IKD SSO** | Login menggunakan Identitas Kependudukan Digital. | **Simulasi** |
| **WhatsApp OTP** | Login cepat menggunakan kode verifikasi WA. | **Simulasi** |
| **Admin Panel** | Kelola OPD, Layanan, Sektor, dan pantau Feedback warga. | **Aktif (Real DB)** |

---

## 3. Audit Keamanan (Vulnerability Assessment)

> [!WARNING]
> **Temuan Kritikal:**
> 1. **Predictable Identity**: Pemisahan data masih bergantung pada string `user_id` manual. Tanpa Token JWT, data rawan dimanipulasi melalui tools API eksternal.
> 2. **Cleartext Communication**: File manifest Android mengizinkan trafik `http://`, yang berisiko terhadap penyadapan data pada jaringan Wi-Fi publik.
> 3. **Verification Gap**: Gerbang login (WA OTP) belum memvalidasi kode secara nyata ke gateway SMS, sehingga semua input 6 digit dianggap sah.

---

## 4. Infrastruktur & Konektivitas

- **Development Bridge:** Menggunakan **ngrok** (`https://nectar-refinish-console.ngrok-free.dev`) untuk mempublikasikan server lokal laptop ke internet.
- **Cross-Platform Logic:** `ApiService` sudah dikonfigurasi untuk otomatis mendeteksi platform:
  - **Browser PC:** Mengakses `localhost:8001`.
  - **HP Fisik:** Mengakses alamat `ngrok` publik.

---

## 5. Rekomendasi Peningkatan (Roadmap)

### Jangka Pendek (Menjelang Launching)
1. **Penerapan JWT (Laravel Sanctum)**: Untuk mengamankan identitas user agar tidak bisa dipalsukan.
2. **Integrasi Gateway WA Nyata**: Menghubungkan ke layanan seperti Fonnte untuk OTP asli.
3. **Optimasi Gambar**: Menambah sistem caching gambar agar loading dashboard lebih cepat.

### Jangka Panjang
1. **Production Hosting**: Memindahkan backend ke server resmi Pemkot (VPS) dengan SSL Sertifikat permanen.
2. **Push Notifications**: Menambah layanan Firebase Cloud Messaging (FCM) agar user mendapat notifikasi getar/suara saat ada balasan chat dari Admin.

---

## 6. Kesimpulan Audit
Project **Sukabumi One Access** sudah memiliki fondasi koding yang sangat rapi dan struktur yang modular. Fitur-fitur utama sudah berjalan dengan sinkronisasi database yang baik. Untuk kebutuhan demo/presentasi saat ini, project sudah berada di kondisi **Sangat Baik**. Namun, penguatan di sisi otentikasi (JWT) wajib dilakukan sebelum aplikasi ini melayani data warga yang sesungguhnya.
