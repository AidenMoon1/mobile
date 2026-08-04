# Implementation Plan - Switch to Ngrok (Remote Access for Multiple Devices)

The goal is to enable the mobile app to connect to the laptop from ANY internet connection (not just local Wi-Fi), allowing multiple users on different devices to submit data to the central database.

## User Review Required

> [!IMPORTANT]
> - I will set the `baseUrl` to your ngrok URL: `https://nectar-refinish-console.ngrok-free.dev/api`.
> - After this change, you MUST build a **NEW APK** and send it to your friend, or they won't be able to connect via ngrok.

## Proposed Changes

### [Flutter Frontend]

#### [MODIFY] [api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)
- Update `baseUrl` getter to return the ngrok URL instead of the local IP when running on mobile.

## Verification Plan

### Manual Verification
1.  **Build & Install**: Create a new APK and install it on two different phones.
2.  **Cellular Data Test**: Turn off Wi-Fi on one of the phones and use cellular data.
3.  **Submission**: Submit a report from both phones.
4.  **MySQL Check**: Open phpMyAdmin and confirm both reports appear in the `aduans` table.
