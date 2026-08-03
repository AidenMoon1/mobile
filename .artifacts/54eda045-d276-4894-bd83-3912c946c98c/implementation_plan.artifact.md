# Implementation Plan - Connect Mobile APK to Local Database

This plan configures the Flutter application to connect to the backend server running on your laptop when installed as an APK on a physical phone.

## Prerequisites

> [!IMPORTANT]
> 1. Your **Phone and Laptop MUST be on the same Wi-Fi network**.
> 2. You must start the Laravel server using the `--host` flag to allow external connections.

## Proposed Changes

### [Android Configuration]

#### [MODIFY] [AndroidManifest.xml](file:///C:/src/mobile/android/app/src/main/AndroidManifest.xml)
- Add `android:usesCleartextTraffic="true"` to the `<application>` tag. This allows the app to communicate with your laptop over `http://` (non-secure), which is required for local testing.

### [Flutter Configuration]

#### [MODIFY] [api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)
- Update `baseUrl` to use your laptop's local IP address: **`http://13.13.13.216:8001/api`**.

## How to Test

### 1. Start the Server correctly
Open your terminal in the `backend/` folder and run:
```bash
php artisan serve --host=0.0.0.0 --port=8001
```
*Using `--host=0.0.0.0` tells Laravel to listen for connections from any device on your Wi-Fi, not just your laptop.*

### 2. Build the new APK
Once the code changes are applied, run:
```bash
flutter build apk --release
```

### 3. Install and Run
Transfer the new `app-release.apk` to your phone, install it, and the app will now be able to save feedback and fetch news directly from your laptop's MySQL database.

## Verification Plan

### Manual Verification
- Install the APK on a phone connected to the same Wi-Fi.
- Open the app and verify that "Berita" (News) is loaded from the server.
- Submit a "Kritik dan Saran" and verify it appears in your laptop's phpMyAdmin.
