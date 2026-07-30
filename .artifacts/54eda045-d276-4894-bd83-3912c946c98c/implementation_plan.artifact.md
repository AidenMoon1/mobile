# Implementation Plan - Production Migration Preparation

This plan prepares the application for production deployment by updating the API connection and generating the necessary distribution files (APK/AAB) and database exports.

## User Review Required

> [!IMPORTANT]
> - **Production URL**: I am using `https://api.sukabumikota.go.id` as the production URL. Please confirm if this is correct or provide the actual URL.
> - **Keystore/Signing**: Ensure you have configured `key.properties` and `build.gradle` for release signing, otherwise the resulting APK will be unsigned.

## Proposed Changes

### [Flutter Frontend]

#### [MODIFY] [api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)
- Comment out the local `baseUrl` (`http://10.0.2.2:8001/api`).
- Add the production `baseUrl` (`https://api.sukabumikota.go.id/api`).

### [Backend/Database]

#### [COMMAND] Export Database
- Execute: `mysqldump -u root db_diskominfo > C:/src/mobile/db_diskominfo_production.sql`
- This file will be created in your project root for you to manually upload to your server.

### [Build Process]

#### [COMMAND] Build APK
- Execute: `flutter build apk --release`

#### [COMMAND] Build App Bundle
- Execute: `flutter build appbundle --release`

## Verification Plan

### Manual Verification
- Check the `build/app/outputs/flutter-apk/` directory for `app-release.apk`.
- Check the project root for `db_diskominfo_production.sql`.
- Verify that the app code now points to the production URL.
