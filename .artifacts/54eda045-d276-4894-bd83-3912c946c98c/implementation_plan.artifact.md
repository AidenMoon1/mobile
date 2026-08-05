# Implementation Plan - Remote Connectivity with Simulated SSO

The goal is to enable the app to work over the internet using your **Ngrok** URL while keeping the new SSO features (IKD & WhatsApp) in **Simulation Mode** as requested.

## User Review Required

> [!TIP]
> - **SSO Status**: Will remain **Simulated**. Users can enter any 6-digit code to log in via WhatsApp.
> - **Database Status**: Will remain **Real**. Reports and Feedback will be saved to your laptop's MySQL database.
> - **Connectivity**: I will use your Ngrok URL (`https://nectar-refinish-console.ngrok-free.dev`) so the app works over cellular data.

## Proposed Changes

### [Flutter Frontend]

#### [MODIFY] [api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)
- Update `_laptopIp` logic or replace with the fixed Ngrok URL.
- Ensure the `ngrok-skip-browser-warning` header is active.

### [Backend/Laravel]

#### [MODIFY] [.env](file:///C:/src/mobile/backend/.env)
- Set `APP_URL` to the Ngrok address.

## Verification Plan

### Manual Verification
1.  **Internet Test**: Turn off Wi-Fi on your phone.
2.  **Submission**: Submit a "Pengaduan" from the phone.
3.  **Check MySQL**: Verify the data appears in your laptop's phpMyAdmin.
4.  **SSO Test**: Verify you can still log in with any random 6-digit code in the WhatsApp screen.
