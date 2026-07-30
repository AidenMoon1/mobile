# Implementation Plan - Advanced Notification Header UI

The goal is to match the `NotificationScreen` header with the detailed reference image, including a top logo bar, a weather widget, and a layered background with an overlapping search bar.

## User Review Required

> [!NOTE]
> I will be extracting the Logo and Weather widget design from `DashboardScreen` to ensure visual consistency across the app. The search bar will be precisely positioned using a `Stack` to overlap the yellow divider line.

## Proposed Changes

### [Notification Screen]

#### [MODIFY] [notification_screen.dart](file:///C:/src/mobile/lib/views/notification_screen.dart)
- **Top Bar**: Add a white container at the top containing:
    - App Logo and "Sukabumi ONE ACCESS" text.
    - Weather widget with temperature, "Terasa seperti", and sun icon.
- **Layered Background**:
    - Light blue section for the "Notifikasi" title.
    - A 4px yellow/orange divider line.
    - Dark blue section with rounded bottom corners.
- **Search Bar**: Position a white capsule-shaped `TextField` to sit on top of the yellow line.
- **Filter Row**: Implement the "Semua Notifikasi" pill button and the right-aligned `tune` and `more_vert` icons inside the dark blue area.
- **Interactivity**: Use `TextEditingController` for the search bar and add tap handlers for icons.

## Verification Plan

### Manual Verification
- Verify the logo and weather widget are correctly aligned.
- Confirm the search bar overlaps the yellow line as per the design.
- Ensure the "Semua Notifikasi" button and other icons respond to taps.
- Verify that sending feedback still populates the notification list correctly within this new UI.
