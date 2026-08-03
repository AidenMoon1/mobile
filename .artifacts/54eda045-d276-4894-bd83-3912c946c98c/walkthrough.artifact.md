# Walkthrough - Connect Mobile APK to Laptop Database

I have configured the application to allow a physical Android phone to connect to the database/server running on your laptop.

## Changes Made

### 1. Networking Configuration
- **[api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)**: Updated the `baseUrl` to use your laptop's local IP address: **`http://13.13.13.216:8001/api`**. This ensures the app on your phone knows exactly where to find your server on the Wi-Fi network.
- **[AndroidManifest.xml](file:///C:/src/mobile/android/app/src/main/AndroidManifest.xml)**: Enabled `android:usesCleartextTraffic="true"`. This is required by Android to allow the app to communicate with your laptop using the unencrypted `http://` protocol.

### 2. Built New Installer
- **Release APK**: Successfully generated a new version of the app at **[app-release.apk](file:///C:/src/mobile/build/app/outputs/flutter-apk/app-release.apk)** (49.9 MB).

## How to Test on Your Phone

> [!IMPORTANT]
> To make the connection work, you MUST follow these steps precisely:

1.  **Wi-Fi Connection**: Make sure your **Phone and Laptop are connected to the same Wi-Fi network**.
2.  **Start the Server with External Access**: Open your terminal in the `backend/` folder and run this specific command:
    ```bash
    php artisan serve --host=0.0.0.0 --port=8001
    ```
    *Note: Using `--host=0.0.0.0` is critical; it allows the server to accept connections from other devices (your phone).*
3.  **Install the APK**: Transfer the new `app-release.apk` to your phone and install it.
4.  **Verify**: Open the app on your phone. You should see news data loading and be able to submit feedback, which will appear in your laptop's MySQL database.

## Verification Results

### Automated Checks
- **IP Detection**: Confirmed laptop IP is `13.13.13.216`.
- **Build Success**: The release APK was built successfully without errors.
- **Security Check**: Verified `usesCleartextTraffic` is correctly placed in the manifest.
