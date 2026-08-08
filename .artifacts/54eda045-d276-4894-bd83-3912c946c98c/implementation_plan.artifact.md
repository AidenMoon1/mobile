# Rencana Perbaikan: Website Beku/Frozen (Web Compatibility)

Rencana ini menangani masalah website `web.app` yang tampil tapi tidak bisa diklik atau diketik. Kita akan meningkatkan stabilitas pemuatan aplikasi di browser.

## User Review Required

> [!IMPORTANT]
> - **HTML Renderer**: Saya akan memaksa aplikasi menggunakan mode HTML saat di-build. Ini akan membuat website Kakak lebih lancar di browser HP dan menghilangkan masalah "tidak bisa dipencet".
> - **CORS & Mixed Content**: Saya akan menyesuaikan `ApiService` agar tidak menyebabkan error keamanan di browser saat aplikasi sudah "online" di internet.

---

## Langkah Perbaikan

### 1. Perbaikan ApiService (Web Security)
Mencegah browser memblokir permintaan data karena perbedaan protokol (HTTPS vs HTTP).
- **[MODIFY] [api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)**: Menyesuaikan deteksi URL untuk versi web yang sudah online.

### 2. Build Web dengan Renderer Stabil
Menjalankan kompilasi dengan parameter khusus untuk kompatibilitas maksimal.
- **Perintah**: `flutter build web --release --web-renderer html`

### 3. Deploy Ulang
Mengunggah versi yang sudah diperbaiki ke Firebase Hosting.
- **Perintah**: `npx firebase deploy --only hosting`

---

## Rencana Verifikasi

### Manual Verification
1. **Akses Link**: Buka kembali `https://sukabumi-one-access-app-c7f15.web.app/`.
2. **Uji Ketik**: Coba ketik di kolom Email/Password.
3. **Uji Klik**: Pastikan tombol "Masuk Akun" dan tombol "Google" merespon sentuhan.
4. **Cek Console**: Tekan F12 di browser, pastikan tidak ada pesan error merah bertuliskan "CORS" atau "Mixed Content".
