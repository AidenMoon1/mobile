# Rencana Perbaikan: Error Null Check di Google SSO Web

Rencana ini menangani error "Null check operator used on a null value" yang terjadi saat mencoba login Google di platform Web. Kita akan beralih ke metode `signInWithPopup` yang lebih stabil untuk browser.

## User Review Required

> [!TIP]
> **Kenyamanan Web**: Dengan metode Popup, warga yang membuka link `web.app` akan melihat jendela kecil baru untuk login Google, sama seperti login di situs-situs besar lainnya. Metode ini tidak memerlukan konfigurasi SHA-1 tambahan.

---

## Langkah Perbaikan

### 1. Modifikasi Logika Login (Platform Branching)
Kita akan memisahkan alur login antara HP dan Web agar masing-masing menggunakan teknologi terbaiknya.
- **[MODIFY] [user_service.dart](file:///C:/src/mobile/lib/services/user_service.dart)**:
    - Jika `kIsWeb` true: Gunakan `_auth.signInWithPopup(GoogleAuthProvider())`.
    - Jika `kIsWeb` false: Gunakan alur `google_sign_in` + `signInWithCredential`.

### 2. Deploy Ulang
Setelah kodingan diperbaiki, kita harus melakukan build dan deploy ulang agar perubahan bisa dirasakan di link `web.app`.

---

## Rencana Verifikasi

### Manual Verification
1. **Akses Link**: Buka [https://sukabumi-one-access-app-c7f15.web.app/](https://sukabumi-one-access-app-c7f15.web.app/).
2. **Uji Login**: Klik tombol "Masuk dengan Google".
3. **Pastikan Popup Muncul**: Verifikasi bahwa tidak ada lagi error merah "Null check", melainkan muncul jendela login Google yang asli.
4. **Cek Profil**: Pastikan Nama dan Foto profil terisi otomatis setelah login sukses.
