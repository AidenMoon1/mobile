# Rencana Implementasi: Autopopulasi Data IKD SSO

Rencana ini menjelaskan bagaimana aplikasi "Sukabumi One Access" secara otomatis mengambil data NIK dan profil warga dari server Dukcapil saat login IKD, sehingga pengguna tidak perlu mengisi data secara manual.

## Konsep Teknis

> [!TIP]
> **Manfaat Utama SSO**: Pengguna mendapatkan kenyamanan "Satu Klik" dan pemerintah mendapatkan jaminan "Data Valid".

### 1. Mekanisme Pengambilan Data (OIDC Scopes)
Saat proses login IKD berlangsung, aplikasi kita akan meminta izin (*Scopes*) untuk mengakses data tertentu:
- `openid`: Untuk identitas akun.
- `profile`: Untuk mengambil nama lengkap.
- `nik`: Khusus IKD, untuk mengambil Nomor Induk Kependudukan resmi.

### 2. Alur Pengisian Otomatis (Auto-Population)
1. **Verifikasi Luar**: Pengguna memasukkan PIN/Scan Wajah di portal resmi IKD (bukan di aplikasi kita).
2. **Penerimaan Token**: IKD mengirimkan token digital ke aplikasi kita.
3. **Ekstraksi Data**: Kodingan di Laravel/Flutter akan membongkar token tersebut dan mengambil data NIK & Nama.
4. **Login Instan**: Aplikasi langsung mengisi profil pengguna dengan NIK asli tersebut dan mengarahkan ke Dashboard.

## Perubahan yang Diusulkan (Simulasi)

### [Frontend/Flutter]

#### [MODIFY] [login_screen.dart](file:///C:/src/mobile/lib/views/profile/login_screen.dart)
- Mengubah simulasi modal IKD.
- Menghilangkan input NIK manual (karena data seharusnya datang dari server).
- Menampilkan indikator "Mengambil Data dari IKD Dukcapil..." sebelum login sukses.

## Rencana Verifikasi

### Manual Verification
- Klik "Masuk dengan IKD".
- Verifikasi bahwa sistem langsung memproses data tanpa meminta user mengetik nomor NIK lagi.
- Cek di halaman Profil: Pastikan nomor NIK yang muncul adalah NIK resmi yang dikirim oleh "server IKD".
