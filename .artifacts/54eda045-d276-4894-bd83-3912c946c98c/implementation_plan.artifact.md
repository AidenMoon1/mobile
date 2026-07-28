# Implementation Plan - Simplify Feedback Screen

The user wants to remove the "Header Card" (Terima kasih!), the "User Data Section" (Data Pengguna), and the footer text from the Feedback screen. This will streamline the form to focus only on the rating and feedback factors.

## User Review Required

> [!IMPORTANT]
> I will be removing the "Jenis Kelamin" (Gender) and "Pendidikan Akhir" (Education) fields from the UI and the underlying data model. If these fields are required for any backend reporting, please let me know, and I can provide default values instead of removing them entirely.

## Proposed Changes

### [Data Model]

#### [MODIFY] [feedback_model.dart](file:///C:/src/mobile/lib/models/feedback_model.dart)
- Remove `gender` and `education` fields from the `FeedbackModel` class and its constructor.

### [Feedback Screen]

#### [MODIFY] [feedback_screen.dart](file:///C:/src/mobile/lib/views/feedback_screen.dart)
- Remove `_selectedGender`, `_selectedEducation`, and `_educations` state variables.
- Update `_submitFeedback` to remove validation for education and simplify the model creation.
- In `_buildFormTab`:
    - Remove the "Header Card" containing the "Terima kasih!" message.
    - Remove the "User Data Section" card.
    - Remove the footer text regarding data usage and thanks.
- Remove the `_buildGenderOption` helper method as it will no longer be used.

## Verification Plan

### Automated Tests
- N/A for UI cleanup, but I will ensure the code compiles without errors.

### Manual Verification
- Review the `FeedbackScreen` to ensure only the "Feedback Layanan" section and the "Kirim Masukan" button remain.
- Test the submission flow to ensure it still works correctly with the simplified model.
