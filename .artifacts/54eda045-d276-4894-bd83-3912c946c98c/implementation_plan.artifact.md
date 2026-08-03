# Implementation Plan - Full Data Integration (HP to MySQL)

The goal is to ensure that EVERY input field in the Flutter app (Feedback, Profile, Reports, and Service Applications) is successfully transmitted and stored in the laptop's MySQL database.

## User Review Required

> [!IMPORTANT]
> - I will modify the `permohonans` table in MySQL to be more flexible (making some address fields nullable) to match the current simplified forms in the Flutter app.
> - I will use the local IP address `13.13.13.216` for all connections to ensure physical device compatibility.

## Proposed Changes

### [Backend/Database Layer]

#### [MODIFY] [2026_07_21_000000_create_permohonans_table.php](file:///C:/src/mobile/backend/database/migrations/2026_07_21_000000_create_permohonans_table.php)
- Make `email`, `provinsi`, `kota`, `kecamatan`, `kelurahan`, `alamat_lengkap`, `rt`, and `rw` nullable to prevent SQL errors when submitting from the simplified mobile form.

#### [NEW] [PermohonanApiController.php](file:///C:/src/mobile/backend/app/Http/Controllers/Api/PermohonanApiController.php)
- Create a controller to handle `POST /api/permohonan` which saves data into the `permohonans` table.

#### [MODIFY] [api.php](file:///C:/src/mobile/backend/routes/api.php)
- Register the `permohonan` route.

### [Frontend/Flutter Layer]

#### [MODIFY] [form_pengajuan_screen.dart](file:///C:/src/mobile/lib/views/form_pengajuan_screen.dart)
- Replace the simulated delay with a real `ApiService.post` call to the new `permohonan` endpoint.
- Include all fields: `nik`, `nama`, `no_kk`, `phone`, and `keterangan`.

#### [VERIFY] [report_screen.dart](file:///C:/src/mobile/lib/views/report_screen.dart)
- Double-check that it correctly points to the `aduan` endpoint and uses the latest `baseUrl`.

## Verification Plan

### Manual Verification
1.  **Server Setup**: Start server with `php artisan serve --host=0.0.0.0 --port=8001`.
2.  **Submit Application**: Open "Layanan Keluarga" -> "KTP" -> "Lanjutkan" in the app on your phone. Fill and submit.
3.  **Check MySQL**: Verify the record appears in the `permohonans` table in phpMyAdmin.
4.  **Submit Report**: Send a report in "Pengaduan". Verify it appears in the `aduans` table.
