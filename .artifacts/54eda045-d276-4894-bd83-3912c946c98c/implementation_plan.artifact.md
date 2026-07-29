# Implementation Plan - Notification System and Screen

The goal is to implement a new Notification system and a dedicated Notification screen as shown in the provided image. The screen will display a list of notifications, grouped by date. Additionally, submitting feedback will now trigger a new notification.

## User Review Required

> [!NOTE]
> The Notification screen is designed based on the provided reference image, featuring a custom header with a search bar and filter options. I will implement a singleton service to manage notifications across the app.

## Proposed Changes

### [Data Model]

#### [NEW] [notification_model.dart](file:///C:/src/mobile/lib/models/notification_model.dart)
- Define `NotificationModel` with `title`, `description`, `timestamp`, and `isRead` status.

### [Service Layer]

#### [NEW] [notification_service.dart](file:///C:/src/mobile/lib/services/notification_service.dart)
- Implement `NotificationService` as a singleton.
- Methods to add and retrieve notifications.

### [UI Components]

#### [NEW] [notification_screen.dart](file:///C:/src/mobile/lib/views/notification_screen.dart)
- Implement the UI based on the reference image:
    - Custom header with "Notifikasi" title and bell icon.
    - Search bar widget.
    - Filter tabs (e.g., "Semua Notifikasi").
    - Grouped list view (Hari Ini, Kemarin, etc.).
    - Notification cards with icons and timestamps.

#### [MODIFY] [main.dart](file:///C:/src/mobile/lib/main.dart)
- Replace the placeholder in `MainNavigationScreen` with the new `NotificationScreen`.

#### [MODIFY] [feedback_screen.dart](file:///C:/src/mobile/lib/views/feedback_screen.dart)
- Update `_submitFeedback` to call `NotificationService.addNotification` after a successful submission.

## Verification Plan

### Manual Verification
1.  Navigate to the "Notifikasi" tab; it should initially be empty or show a placeholder if no notifications exist.
2.  Go to the "Kritik dan Saran" screen and submit feedback.
3.  Observe the success dialog.
4.  Navigate back to the "Notifikasi" tab and verify that a new notification entry exists with the title "Terima kasih telah mengisi kritik dan saran!".
5.  Check if the grouping (e.g., "Hari Ini") works as expected.
