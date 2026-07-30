# Walkthrough - Production Migration Files Ready

I have successfully completed the local preparation for your production migration. All necessary files have been generated and are ready for upload.

## Summary of Completed Tasks

### 1. API Configuration Updated
- **[api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)**: The `baseUrl` has been switched from local (`http://10.0.2.2:8001/api`) to production: **`https://api.sukabumikota.go.id/api`**.

### 2. Database Export Generated
- **File**: [db_diskominfo_production.sql](file:///C:/src/mobile/db_diskominfo_production.sql)
- **Action Required**: Upload and import this file into your production MySQL database (via phpMyAdmin or CLI).

### 3. Distribution Files Built
I have successfully built the release versions of the application:
- **Release APK**: [app-release.apk](file:///C:/src/mobile/build/app/outputs/flutter-apk/app-release.apk) (51.3 MB)
    - *Use this for direct installation on Android devices.*
- **App Bundle (AAB)**: [app-release.aab](file:///C:/src/mobile/build/app/outputs/bundle/release/app-release.aab) (50.4 MB)
    - *Use this for publishing to the Google Play Store.*

## Verification Results

### Automated Checks
- **Disk Space**: Confirmed 32GB+ of free space before building.
- **Build Status**: Both `assembleRelease` and `bundleRelease` tasks finished with `SUCCESS`.
- **Database Export**: Verified the file was created using `mysqldump`.

## Final Steps for You

> [!IMPORTANT]
> 1. **Upload Backend**: Follow the previous instructions to upload your `backend/` folder to the server.
> 2. **Import SQL**: Import the `db_diskominfo_production.sql` file into your server's database.
> 3. **Distribute App**: Share the `.apk` file with your users or upload the `.aab` file to the Google Play Console.

> [!TIP]
> If you need to make more changes locally, remember to switch the `baseUrl` back to local in `api_service.dart` to test with your local server.
