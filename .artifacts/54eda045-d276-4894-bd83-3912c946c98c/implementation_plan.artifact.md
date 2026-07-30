# Implementation Plan - Update Privacy Policy Screen UI

Update the `TermsAndPolicyScreen` to match the detailed design in the provided reference image, featuring grouped policy sections and a structured header.

## User Review Required

> [!NOTE]
> - The policy sections (e.g., "Dasar Hukum", "Data Pribadi Pengguna") will be implemented as static list items for now. Clicking them can show a dummy message or be prepared for future detailed views.
> - I will use the established color palette (`primaryColor: 0xFF0A1E33`, `accentColor: 0xFFE8A33D`).

## Proposed Changes

### [Kebijakan dan Ketentuan Screen]

#### [MODIFY] [terms_and_policy_screen.dart](file:///C:/src/mobile/lib/views/terms_and_policy_screen.dart)
- **Background**: Update body to have a dark blue background behind the rounded white container to create the "card" effect shown in the image.
- **Header Section**:
    - Title: "KEBIJAKAN PRIVASI" (Uppercase, bold).
    - Version Badge: "Versi 5.4.3" in an orange rounded box.
    - Update Date: Calendar icon + "Diperbarui per tanggal 23 Desember 2026".
    - Intro Text: The paragraph explaining data collection and usage.
- **Policy Sections List**:
    - Implement a list of items: "Dasar Hukum", "Data Pribadi Pengguna", "Data Non-Pribadi Pengguna", "Cookies", "Bagaimana Kami Menggunakan Data", etc.
    - Each item will have a chevron-right icon and a bottom divider.
    - Styling will match the image (bold text, clean spacing).

## Verification Plan

### Manual Verification
- Navigate to the "Kebijakan dan Ketentuan" screen from the Profile screen.
- Verify the header elements (Version, Date, Title) are correctly placed.
- Ensure the list of policy sections is complete and matches the reference image.
- Verify that the layout remains responsive on scroll.
