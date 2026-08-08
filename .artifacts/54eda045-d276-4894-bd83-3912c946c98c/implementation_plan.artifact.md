# Rencana Implementasi: Deploy Firebase & Perbaikan Kompatibilitas Web

Rencana ini mencakup proses pembaruan aplikasi web Kakak ke Firebase Hosting, sekaligus memastikan website tersebut tidak "hang" (macet) dan bisa mengambil data dari server laptop Kakak meskipun diakses lewat internet.

## User Review Required

> [!IMPORTANT]
> - **Konektivitas Live**: Saya akan mengubah `ApiService` agar versi web menggunakan alamat **ngrok**. Tanpa ini, website Kakak di internet tidak akan bisa menampilkan berita atau melakukan login karena mencoba memanggil `localhost` (laptop user sendiri).
> - **HTML Renderer**: Kita akan menggunakan renderer HTML agar website lebih lancar di browser HP.

---

## Langkah-Langkah Eksekusi

### 1. Penyesuaian Jalur Data (API)
Mengaktifkan alamat publik ngrok untuk versi web agar bisa "berbicara" dengan laptop Kakak dari internet.
- **[MODIFY] [api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)**

### 2. Kompilasi Kode (Build Web)
Membangun file website dengan optimasi stabilitas.
- **Perintah**: `flutter build web --release --web-renderer html`

### 3. Pengunggahan (Deploy Firebase)
Mengirim file terbaru ke `https://sukabumi-one-access-app-c7f15.web.app/`.
- **Perintah**: `npx firebase deploy --only hosting`

---

## Rencana Verifikasi

### Manual Verification
1. **Akses Link**: Buka `https://sukabumi-one-access-app-c7f15.web.app/`.
2. **Uji Responsif**: Pastikan tombol bisa diklik dan input bisa diketik.
3. **Uji Data**: Pastikan daftar berita muncul (menandakan koneksi ke Laravel via ngrok berhasil).
4. **Uji Login**: Coba login Google atau Email OTP di versi web tersebut.
