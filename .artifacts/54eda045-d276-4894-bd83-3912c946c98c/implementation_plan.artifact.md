# Rencana Perbaikan Menyeluruh: Layar Putih & Error Kompilasi Admin

Rencana ini menangani dua masalah utama: kegagalan kompilasi pada Dashboard Admin dan masalah layar putih pada Flutter Web.

## Masalah Utama

> [!CRITICAL]
> 1. **Error Kompilasi**: `AdminDashboardScreen` mencoba memanggil `AdminFeedbackListScreen` sebagai `const`, padahal kelas tersebut tidak ada atau tidak valid sebagai konstanta.
> 2. **Layar Putih (Web)**: Impor `dart:io` dan `sqflite` menyebabkan crash instan di browser karena pustaka tersebut hanya untuk HP.

## Langkah Perbaikan

### 1. Perbaikan Error Kompilasi (Admin Dashboard)
- **[MODIFY] [admin_dashboard_screen.dart](file:///C:/src/mobile/lib/views/admin/admin_dashboard_screen.dart)**:
    - Menghapus keyword `const` pada pemanggilan `AdminFeedbackListScreen`.
    - Memperbaiki impor yang hilang.
- **[NEW] [admin_feedback_list_screen.dart](file:///C:/src/mobile/lib/views/admin/admin_feedback_list_screen.dart)**: Membuat ulang file yang hilang agar sistem bisa berjalan.
- **[MODIFY] [feedback_model.dart](file:///C:/src/mobile/lib/models/feedback_model.dart)** & **[feedback_service.dart](file:///C:/src/mobile/lib/services/feedback_service.dart)**: Menambahkan dukungan untuk data lintas pengguna.

### 2. Perbaikan Layar Putih (Web Compatibility)
- **[MODIFY] [database_helper.dart](file:///C:/src/mobile/lib/services/database_helper.dart)**: Menghapus impor `sqflite` yang tidak aman untuk web.
- **[MODIFY] [smart_image.dart](file:///C:/src/mobile/lib/widgets/smart_image.dart)**: Menghapus total impor `dart:io` dan menggantinya dengan pengecekan platform yang aman.

## Rencana Verifikasi

### Manual Verification
1. **Stop & Run**: Hentikan proses lama dan jalankan `flutter run -d chrome`.
2. **Cek Login**: Pastikan layar login muncul dan tidak putih.
3. **Cek Admin**: Masuk ke Dashboard Admin -> Kelola Feedback, pastikan tidak ada error.
