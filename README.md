# Enyx Flutter Starter Kit

A production-focused Flutter starter for Supabase auth, feature-first screens, Riverpod state, and reusable liquid-glass UI.

## Overview

- Feature-first app structure under `lib/features`
- Core shared modules under `lib/core`
- Supabase auth + deep-link redirect flow
- Shell-based bottom tab navigation with smooth transitions
- Liquid-glass widgets provided via `glovex_liquid_ui`
- Localization enabled (`en`, `bn`)

## Tech Stack

- `flutter_riverpod`
- `go_router`
- `supabase_flutter`
- `dio`
- `flutter_dotenv`
- `glovex_liquid_ui`

## Project Structure

- `lib/features`: feature modules (`auth`, `home`, `profile`, `settings`, `settings_two`, etc.)
- `lib/core/config`: env, feature flags
- `lib/core/routing`: router and auth redirect logic
- `lib/core/ui`: app shell widgets
- `lib/core/localization`: ARB and generated l10n
- `lib/backend`: Supabase and API service wrappers

## Environment Setup

Create `.env` at project root:

```env
FLAVOR=dev
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
OAUTH_REDIRECT_URL=com.enyx.starter://login-callback
API_BASE_URL=https://api.example.com
```

Start from `.env.example` and replace values.

## Run

```bash
flutter pub get
flutter run
```

## iOS/macOS Notes

- Ensure deep-link scheme matches `OAUTH_REDIRECT_URL`
- If pods/desync issues appear:

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
cd macos && pod install && cd ..
flutter run
```

## Routing Model

- Auth pages are normal routes (`/login`, `/register`, `/forgot-password`)
- Main tabs are inside a shell route
- Bottom nav stays fixed while tab content transitions
- Route paths are centralized in `lib/core/routing/app_router.dart`

## Liquid UI Usage

This app consumes `glovex_liquid_ui` from a local path dependency. Update `pubspec.yaml` if you want pub.dev version instead:

```yaml
glovex_liquid_ui: ^0.1.0
```

Current local path setup:

```yaml
glovex_liquid_ui:
  path: /Users/mac/enyx/packages/enyx_liquid_ui
```

## Useful Commands

```bash
flutter analyze
flutter test
flutter pub outdated
```

## References

- `FREEZED_GUIDE.md`
- `lib/core/utils/app_sizes.dart`
