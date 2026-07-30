# Implementation Plan - Fix White Screen on Web

The app is currently crashing on startup when running in a web browser because `sqflite` (SQLite) is not supported on the web. This plan will make the database initialization conditional.

## User Review Required

> [!IMPORTANT]
> - Data persistence for Notifications and Feedback will be **disabled on Web** to prevent crashes.
> - Data persistence will continue to work normally on **Android and iOS**.
> - For production web persistence, a different plugin like `hive` or `drift` would be needed, but for now, we will focus on getting the app running again.

## Proposed Changes

### [Database Layer]

#### [MODIFY] [database_helper.dart](file:///C:/src/mobile/lib/services/database_helper.dart)
- Add `import 'package:flutter/foundation.dart' show kIsWeb;`.
- Modify the `database` getter and `insert/query` methods to return empty results or skip execution if `kIsWeb` is true.

### [Service Layer]

#### [MODIFY] [notification_service.dart](file:///C:/src/mobile/lib/services/notification_service.dart)
#### [MODIFY] [feedback_service.dart](file:///C:/src/mobile/lib/services/feedback_service.dart)
- Ensure they don't wait for database responses that will never come if on Web.

## Verification Plan

### Manual Verification
1.  Run the app in Chrome: Verify the white screen is gone and the app renders correctly.
2.  Run the app in Android Emulator: Verify that feedback and notifications are still being saved to the local database.
