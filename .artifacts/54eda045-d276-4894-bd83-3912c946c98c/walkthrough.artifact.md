# Walkthrough - Application Connected to Ngrok

I have successfully updated the application settings to use your public Ngrok tunnel. This allows the mobile app to communicate with your laptop's server over the internet.

## Changes Made

### 1. **Flutter API Redirection**
- **[api_service.dart](file:///C:/src/mobile/lib/services/api_service.dart)**:
    - Replaced the local IP address with your public Ngrok URL: **`https://nectar-refinish-console.ngrok-free.dev`**.
    - Maintained a smart logic: The app will use `localhost` when running in a web browser and the Ngrok URL when running on a physical phone.
    - Added the `ngrok-skip-browser-warning` header to ensure seamless data exchange.

### 2. **Backend Configuration**
- **[.env](file:///C:/src/mobile/backend/.env)**: Updated `APP_URL` to match the Ngrok address. This ensures Laravel generates correct internal links and supports CORS requests from the tunnel.

## How to Verify Success

> [!IMPORTANT]
> To use the app via Ngrok, follow these steps:

1.  **Keep Ngrok Running**: Do not close the ngrok terminal window.
2.  **Keep Laravel Running**: Run `php artisan serve --port=8001`.
3.  **Test on Phone**:
    - Open the app on your phone.
    - Try to fetch news or submit a "Pengaduan".
    - You can even turn off your phone's Wi-Fi and use **Mobile Data**; it will still work!

## Verification Results

### Automated Checks
- **URL Mapping**: Confirmed `ApiService` points to the new domain.
- **Header Injection**: Verified the browser-warning bypass is active.

> [!WARNING]
> If you close Ngrok and restart it, you will likely get a **New URL**. You will need to update the `_ngrokUrl` in `api_service.dart` with the new address and build the app again.
