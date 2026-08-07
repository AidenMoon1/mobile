# Rencana Implementasi: Update Website (Firebase Hosting)

Rencana ini bertujuan untuk memperbarui isi website resmi **Sukabumi One Access** di alamat `https://sukabumi-one-access-app-c7f15.web.app/` agar sesuai dengan kodingan terbaru (termasuk fitur Login Google asli) yang ada di laptop Kakak.

## User Review Required

> [!IMPORTANT]
> - **Proses Build**: Saya akan menjalankan perintah `flutter build web`. Proses ini mungkin memakan waktu 2-5 menit tergantung kecepatan laptop.
> - **Koneksi Internet**: Dibutuhkan koneksi internet yang stabil untuk mengunggah file (sekitar 10-20MB) ke server Firebase.

---

## Langkah-Langkah Eksekusi

### 1. Kompilasi Kode ke Web (Build)
Mengubah kodingan Flutter menjadi file website yang dimengerti browser.
- **Perintah**: `flutter build web --release`
- **Output**: File akan dihasilkan di folder `build/web/`.

### 2. Pengunggahan ke Firebase (Deploy)
Mengirim file hasil build ke server hosting Google.
- **Perintah**: `npx firebase deploy --only hosting`
- **Hasil**: Perubahan akan langsung aktif di link `web.app` tersebut.

---

## Rencana Verifikasi

### Manual Verification
1. **Akses Link**: Buka `https://sukabumi-one-access-app-c7f15.web.app/` di browser.
2. **Cek Fitur**:
    - Pastikan logo Google terbaru sudah muncul.
    - Pastikan klik tombol Google memicu login asli.
    - Pastikan fitur IKD dan WhatsApp (Simulasi) tetap berjalan.
3. **Responsive Test**: Coba buka link tersebut dari **Browser HP**. Pastikan tampilannya tetap rapi seperti aplikasi mobile.
