# Walkthrough - Notification Screen UI Enhancement

I have updated the `NotificationScreen` UI to match the latest design requirements, featuring a redesigned header and improved interactivty.

## Changes

### [Notification Screen](file:///C:/src/mobile/lib/views/notification_screen.dart)

- **Redesigned Header:**
    - Implemented a layered background effect with light blue and dark blue sections.
    - Updated icons: A prominent bell icon with a notification dot on the left, and an info ("i") icon on the right.
    - Centered "Notifikasi" title with updated typography.
- **Interactable Search Bar:**
    - The search bar is now functional and features a drop shadow for depth.
- **Improved Filter Row:**
    - The "Semua Notifikasi" tab is now a tappable button with a chevron icon.
    - Added interactivty to the **Filter (tune)** and **More Options (vertical dots)** icons.
    - Interactive elements now show feedback (SnackBar) when tapped.
- **Persistent Logic:**
    - The screen continues to show an "empty state" by default but will dynamically display notifications as they are added (e.g., from the Feedback screen).

## Verification

### Manual Verification
- Navigated to the "Notifikasi" tab and confirmed the new header design and layered colors.
- Tested typing in the search bar.
- Tapped on the Info, Filter Tab, Filter Icon, and More Menu; all provided visual feedback via SnackBars.
- Submitted feedback in the "Kritik dan Saran" screen and confirmed the notification appeared correctly in the new UI.

> [!TIP]
> The new design provides a more premium feel and clearer hierarchy for the notification center. The interactable elements are ready for integration with real backend search and filtering logic.
