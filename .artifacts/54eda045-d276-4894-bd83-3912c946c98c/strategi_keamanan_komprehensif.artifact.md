# Strategi Keamanan Komprehensif: Sukabumi One Access
**Status:** Draf Pengembangan (Simulasi)
**Versi:** 1.0
**Tanggal:** 5 Agustus 2026

---

## I. Pendahuluan
Dokumen ini disusun untuk memberikan gambaran menyeluruh mengenai postur keamanan aplikasi **Sukabumi One Access**. Dokumen ini menggabungkan analisis risiko saat ini dengan rencana perbaikan (roadmap) menuju sistem yang siap produksi (production-ready).

---

## II. Analisis Celah Keamanan (Kondisi Saat Ini)

### 1. Autentikasi & Otorisasi (Kontrol Akses yang Lemah)
*   **Kelemahan:** Sistem saat ini menggunakan pengenal statis (`user_id = "ID-1003"`) yang dikirim dalam teks biasa tanpa tanda tangan digital.
*   **Risiko:** Potensi **ID Spoofing** (pemalsuan identitas). Pengguna dapat dengan mudah mengubah parameter permintaan untuk mengakses data pribadi milik warga lain.

### 2. Transmisi Data (Paparan Teks Polos)
*   **Kelemahan:** Pengaturan `android:usesCleartextTraffic="true"` masih aktif, mengizinkan komunikasi via `http://`.
*   **Risiko:** Kerentanan terhadap **Packet Sniffing** dan serangan **Man-in-the-Middle (MitM)**, di mana data sensitif seperti NIK atau nomor WhatsApp dapat disadap pada jaringan Wi-Fi publik.

### 3. Validasi Gerbang Login (Simulasi OTP & IKD)
*   **Kelemahan:** Fitur login WhatsApp OTP dan IKD masih bersifat simulasi (menerima input kode apa saja).
*   **Risiko:** Tidak adanya barrier keamanan yang nyata, memungkinkan akses tidak sah ke akun pengguna mana pun.

---

## III. Roadmap Penguatan Sistem (Security Hardening)

### Fase 1: Implementasi Token Digital (JWT/Sanctum)
Guna mengatasi kelemahan autentikasi, sistem akan beralih ke metode **Token-Based Authentication**.
- **Mekanisme:** Server menerbitkan token kriptografis unik setelah login berhasil.
- **Keamanan:** Setiap permintaan data ke server wajib menyertakan token ini dalam header. Server akan memvalidasi token untuk memastikan pemanggil data adalah pemilik sah data tersebut.

### Fase 2: Integrasi Gateway WhatsApp & IKD Resmi
Mengubah logika simulasi menjadi fungsionalitas nyata.
- **WhatsApp:** Menghubungkan Laravel ke API Gateway (seperti Fonnte). Kode OTP akan dikirim secara nyata dan divalidasi dengan batas waktu 5 menit.
- **IKD:** Melakukan jabat tangan (handshake) OpenID Connect resmi dengan server Dukcapil untuk menjamin keaslian data kependudukan.

### Fase 3: Enkripsi End-to-End (HTTPS/SSL)
Mengamankan jalur komunikasi data.
- **Enforcement:** Mematikan izin `CleartextTraffic` di Android dan mewajibkan penggunaan protokol `https://`.
- **Sertifikasi:** Pemasangan sertifikat SSL (Let's Encrypt atau SSL berbayar) pada domain resmi pemerintah.

---

## IV. Ringkasan Prioritas Tindakan

| Prioritas | Tindakan Utama | Dampak Keamanan | Status |
| :--- | :--- | :--- | :--- |
| **KRITIKAL** | Migrasi ke Laravel Sanctum (Token) | Sangat Tinggi | Simulasi |
| **TINGGI** | Koneksi API WhatsApp Gateway Asli | Tinggi | Simulasi |
| **SEDANG** | Enkripsi SSL & Blokir HTTP Biasa | Menengah | Belum Ada |

---

## V. Kesimpulan
Meskipun saat ini sistem berada dalam mode simulasi untuk keperluan demo yang lancar, penerapan strategi di atas menjadi **syarat mutlak** sebelum aplikasi ini didistribusikan ke masyarakat luas untuk menjamin privasi dan keamanan data warga Kota Sukabumi.
