# Implementation Plan - Fix AndroidManifest.xml Warnings and Errors

The current `AndroidManifest.xml` has several warnings and errors related to unresolved classes and unknown attributes. This plan aims to fix these by providing more explicit information to the IDE and correcting structural omissions.

## User Review Required

> [!IMPORTANT]
> The `${applicationName}` placeholder is standard in Flutter projects but often shows as an error in Android Studio's static analysis. I will keep it if it's essential for the build process, or replace it with the default `io.flutter.app.FlutterApplication` if appropriate. However, for a standard Flutter v2 embedding, it might not even be necessary.

## Proposed Changes

### [AndroidManifest.xml](file:///C:/src/mobile/android/app/src/main/AndroidManifest.xml)

#### [MODIFY] [AndroidManifest.xml](file:///C:/src/mobile/android/app/src/main/AndroidManifest.xml)
- Add the XML declaration `<?xml version="1.0" encoding="utf-8"?>`.
- Add `package="com.diskominfo.mobile"` to the `<manifest>` tag. This helps the IDE resolve relative class names, even though AGP 7+ uses `namespace` in `build.gradle`.
- Change `android:name=".MainActivity"` to `android:name="com.diskominfo.mobile.MainActivity"` for explicit resolution.
- Verify if `android:name="${applicationName}"` can be safely replaced or if the error can be ignored. Given the user wants to "fix" it, I will check if removing it or using a concrete class is better. For now, I will try adding `xmlns:tools="http://schemas.android.com/tools"` and potentially using `tools:ignore` if it's just a lint issue, but it's reported as a hard error by `analyze_file`.

## Verification Plan

### Automated Tests
- Call `analyze_file` on `AndroidManifest.xml` after changes.
- Check for any new errors introduced.

### Manual Verification
- N/A (I will rely on the static analysis tool).
