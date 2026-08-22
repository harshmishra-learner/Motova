# Motova — Mobile App (Flutter)

Motova is a vehicle rental/booking mobile app. This is the **Flutter client** — it talks to a separate Node.js/Express backend (in the sibling `server/` repo) for authentication, and currently uses local mock data for the car catalog and bookings.

> Looking for the full technical deep-dive (architecture, every screen, the Google Sign-In flow end-to-end, API contract, security notes)? See the project documentation shared alongside this repo. This README only covers what you need to get the app running and find your way around.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Connecting to the Backend](#connecting-to-the-backend)
- [Google Sign-In Setup](#google-sign-in-setup)
- [Troubleshooting](#troubleshooting)
- [Known Limitations / Roadmap](#known-limitations--roadmap)
- [Coding Conventions](#coding-conventions)

---

## Features

| Feature | Status |
|---|---|
| Onboarding | ✅ Complete |
| Sign up (email/password) | ✅ Wired to backend |
| Login (email/password) | ✅ Wired to backend |
| Google Sign-In | ✅ Wired to backend (Login screen only — not yet on Signup) |
| Apple Sign-In | 🚧 UI only, not implemented |
| Forgot Password / OTP / Reset Password | ✅ Wired to backend |
| Session persistence | ✅ Via `flutter_secure_storage` |
| Auto-login on app restart | 🚧 Not implemented — app always opens on Onboarding |
| Home (browse cars) | ✅ Built, using local mock catalog data |
| Search (search + filter cars) | ✅ Built, using local mock catalog data |
| My Vehicles (bookings) | ✅ Built, using local mock booking data |
| Notifications | 🚧 Built, using local mock data |
| Profile / Edit Profile | 🚧 Built, using local mock user data (not the real logged-in user) |
| Logout | 🚧 UI only — doesn't yet clear the stored session |

---

## Tech Stack

- **Flutter** `^3.12.2` (Dart)
- **go_router** — navigation
- **dio** — HTTP client, used by the auth data layer
- **flutter_secure_storage** — stores the access token + user info after login
- **firebase_core** + **google_sign_in** — native Google Sign-In flow
- **provider**, **cached_network_image**, **flutter_animate**, **image_picker** — declared, minimal/no use yet

---

## Project Structure

```
lib/
├── main.dart                    # Entry point — initializes Firebase, runs the app
├── firebase_options.dart         # Generated Firebase config (per platform)
├── app/
│   ├── routes.dart                # All app routes (go_router)
│   ├── app_shell.dart             # Bottom-nav shell (Home/Search/Vehicles/Notifications/Profile)
│   └── theme/                     # Design tokens: colors, spacing, text styles, ThemeData
├── core/
│   ├── constants/
│   │   ├── app_constants.dart      # Misc app-wide constants (e.g. OTP length)
│   │   └── api_constants.dart      # Backend base URL + endpoint paths — see below
│   ├── network/
│   │   └── dio_client.dart         # Shared configured Dio instance
│   └── utils/validators.dart
├── features/
│   ├── auth/                      # Login, Signup, Forgot Password, OTP, Reset Password
│   │   ├── data/                    # AuthApiService -> AuthRepository -> AuthStorage
│   │   ├── models/
│   │   └── presentation/
│   ├── home/presentation/          # Browse cars — category chips, popular carousel, recommended list
│   ├── search/presentation/        # Search + filter the car catalog
│   ├── vehicles/                   # My bookings (Upcoming / Completed)
│   ├── notifications/
│   └── profile/
└── shared/
    ├── widgets/                    # Reusable components (buttons, fields, cards, chips...)
    └── models/                     # Models shared across features (e.g. CarListing)
```

Each feature follows the same shape: `presentation/` for screens, `models/` for its data classes, and — for `auth` only, so far — a `data/` layer for real API calls. **This is the pattern to copy** when wiring up Home/Search/Vehicles/Notifications/Profile to a real backend later.

---

## Getting Started

**Prerequisites**
- Flutter SDK matching `^3.12.2` (`flutter --version` to check)
- Android Studio / Xcode, depending on your target platform
- The backend running (see the `server/` repo's own README) — needed for Signup/Login/Google Sign-In/Password Reset to work

**Setup**

```bash
git clone <this-repo-url>
cd motova

flutter pub get
flutter run                 # picks a connected device/emulator
```

The app will boot into Onboarding → you can browse the full UI without a backend, but **any screen that hits the network (Signup, Login, Google Sign-In, Forgot Password) needs the backend reachable** — see the next section.

---

## Connecting to the Backend

The backend's URL is a single constant in `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'http://192.168.1.43:5000'; // ← change this
  ...
}
```

This is **hardcoded to a specific developer's machine IP** — you need to update it to point at wherever your backend is actually running:

| Where you're running the app | `baseUrl` should be |
|---|---|
| Physical Android/iOS device, backend on your laptop | `http://<your laptop's LAN IP>:5000` (same Wi-Fi network as the phone) |
| Android Emulator, backend on the host machine | `http://10.0.2.2:5000` |
| iOS Simulator or a desktop target, backend on the same machine | `http://localhost:5000` |

After changing this constant, **do a full restart** (not hot reload) — it's a `static const`, read once.

Android already has `usesCleartextTraffic="true"` set in `AndroidManifest.xml`, so plain `http://` works for local dev. This should be swapped for a real `https://` backend before any production build.

---

## Google Sign-In Setup

- **Android** — already configured. `android/app/google-services.json` and the Gradle Google Services plugin are in place.
- **iOS** — **not yet configured.** Google Sign-In will not work on iOS until a `GoogleService-Info.plist` is added to `ios/Runner/` and the reversed-client-ID URL scheme is added to `Info.plist` (via the FlutterFire CLI or manually through the Firebase Console).
- **Backend requirement** — the backend must have `GOOGLE_CLIENT_ID` set to the project's **Web** OAuth client ID (not the Android/iOS one) for token verification to succeed. See the backend's own README/`Google_signin.md` for the exact value.

---

## Troubleshooting

**"Connection timed out. Please try again." on Signup/Login/Google Sign-In**

This means the app couldn't reach the backend within 10 seconds — almost always a network configuration issue, not a code bug. Check, in order:

1. **Is the backend actually running?** Check its terminal for `Server running on port 5000` with no crash after it.
2. **Is `ApiConstants.baseUrl` pointing at the right IP?** Laptops on Wi-Fi get new IPs often — re-check with `ipconfig` (Windows) / `ifconfig` (Mac/Linux) and update the constant if it's stale.
3. **Are the phone and the backend machine on the same network?** Different Wi-Fi bands, a VLAN, or one being on Ethernet while the other's on Wi-Fi can all break this even with the right IP.
4. **Is a firewall blocking port 5000?** Windows Defender / macOS firewall can silently drop incoming connections from other devices on the network — this looks exactly like a timeout.
5. **Sanity check:** open `http://<backend-IP>:5000/` directly in the phone's browser. You should see `{ "status": "Server running successfully" }`. If the browser can't load it either, it's confirmed to be network/firewall — not Flutter.

**Google Sign-In fails with a generic error after picking an account**

Almost always means the backend's `GOOGLE_CLIENT_ID` env var is unset or set to the wrong client ID (must be the **Web** client, not Android/iOS). Check the backend logs for the actual verification error.

---

## Known Limitations / Roadmap

- No session bootstrap — a returning user with a valid saved token still sees Onboarding/Login every time the app opens.
- Logout doesn't clear the stored session yet (the `AuthStorage.clearSession()` method exists and is unused).
- Google Sign-In is only wired on the Login screen, not Signup.
- Apple Sign-In has no implementation on either screen.
- Home / Search / Vehicles / Notifications / Profile all currently run on local mock data — no backend endpoints exist yet for catalog, bookings, notifications, or profile read/update.
- OTP input is 4 digits in the UI; the backend currently issues 6-digit OTPs. These need to be aligned before the password-reset flow is fully testable end-to-end against the real backend.

## Coding Conventions

- Feature-first structure: `lib/features/<name>/{data,models,presentation}`. Cross-feature widgets/models go in `lib/shared/`.
- All colors/spacing/typography come from `AppColors` / `AppDimensions` / `AppTextStyles` (`lib/app/theme/`) — no inline hardcoded values in screens.
- Navigate only via `AppRoutes.<name>` constants and `context.go(...)` / `context.push(...)` — never `Navigator.push` directly.
- Any half-finished integration point is marked `// TODO: ...` in the code — grep for `TODO` before assuming a feature is fully wired.