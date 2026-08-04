# Implementation Plan - Notification Filter Dropdown

The user wants to add a functional filter dropdown to the notification screen with specific categories: "Semua Notifikasi", "Informasi", "Layanan", and "Kebencanaan".

## Proposed Changes

### [Notification Screen]

#### [MODIFY] [notification_screen.dart](file:///C:/src/mobile/lib/views/notification_screen.dart)
- **State Management**:
    - Add `String _selectedFilter = 'Semua Notifikasi'` to the state.
    - Implement filtering logic in `build` to filter the notification list by category and search text.
- **UI Update**:
    - Replace the static `_buildFilterTab` with a `PopupMenuButton` to show the filter options.
    - Style the dropdown button and menu items to match the reference image (white background, gold chevron, navy text).
    - Map internal `NotificationCategory` enum values to the display names:
        - "Semua Notifikasi" -> `null` (no filter)
        - "Informasi" -> `NotificationCategory.news` (or general)
        - "Layanan" -> `NotificationCategory.service`
        - "Kebencanaan" -> `NotificationCategory.general` (or add a new category)

## Verification Plan

### Manual Verification
- Click on "Semua Notifikasi" and verify the dropdown menu appears with the 4 options.
- Select "Layanan" and verify only service notifications are shown.
- Verify the search bar still works in combination with the filter.
- Check the visual alignment of the chevron and text in the dropdown button.
