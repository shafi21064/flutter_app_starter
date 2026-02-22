# Enyx Flutter Starter Kit 🚀

A production-grade, feature-first boilerplate designed for scale, speed, and clean code.

## 🏗 Architecture (Feature-First)

The app follows a **Feature-First** folder structure, ensuring that each feature is self-contained and modular.

### 1. Feature Layer (`lib/features/`)
Each feature (e.g., `auth`, `profile`) is organized into:
*   **Domain**: Pure business logic (Entities, Repository interfaces).
*   **Data**: External data implementations (DTOs, Repository implementations, Data Sources).
*   **Presentation**: UI components and state management.
    *   **Controllers**: Riverpod Notifiers that manage state and handle logic. They only communicate with Domain Entities.
    *   **Views**: Cupertino-styled widgets that observe Controllers.

### 2. Core Layer (`lib/core/`)
Contains shared infrastructure, utilities, and cross-cutting concerns:
*   **config**: Environment variables and feature flags.
*   **connectivity**: Internet connection awareness.
*   **deep_links**: App-to-app and web-to-app routing.
*   **localization**: Multi-language support (l10n).
*   **logging**: Centralized logging system.
*   **models**: Base/shared models (e.g., `api_model`).
*   **networking**: Rest API clients (Dio).
*   **result**: Typed error handling using `Result<T>`.
*   **routing**: Declarative navigation (GoRouter).
*   **storage**: Secure and key-value storage.
*   **theme**: Cupertino tokens and custom styling.
*   **ui**: Shared atomic widgets and design tokens.
*   **utils**: General helpers (sizes, haptics, extensions).
*   **CI/CD**: Automated GitHub Actions for analysis.

---

## 🛠 Tech Stack

*   **UI**: Full Cupertino (iOS) design system.
*   **State Management**: [Riverpod](https://riverpod.dev) (The modern standard).
*   **Navigation**: [GoRouter](https://pub.dev/packages/go_router) (Declarative & URL-based).
*   **Backend**: [Supabase](https://supabase.com) (Auth, DB, Storage).
*   **Logic Isolation**: [Freezed](https://pub.dev/packages/freezed) & [JsonSerializable](https://pub.dev/packages/json_serializable) for immutable models.
*   **Networking**: [Dio](https://pub.dev/packages/dio) with custom interceptors.
*   **Modern UI Logic**: [Flutter Hooks](https://pub.dev/packages/flutter_hooks) for boilerplate-free widgets.
*   **Environment**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv).

---

## 🚀 Getting Started

### 1. Configuration
Create a `.env` file in the root:
```env
FLAVOR=dev
SUPABASE_URL=your_url
SUPABASE_ANON_KEY=your_key
API_BASE_URL=https://api.example.com
```

### 2. Run the App
```bash
# Get dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Launch
flutter run
```

---

## 🔧 Workflow Guide

### Adding a New Feature
1. Create a folder in `lib/features/<name>`.
2. Define your **Entity** in `domain/entities/`.
3. Define your **DTO** in `data/models/` and run `build_runner`.
4. Implement the **Repository**.
5. Create a **Controller** in `presentation/controller/` and a **View** in `presentation/view/`.

### Handling API Changes
If an API field changes, only edit the **DTO** mapping logic. Your **Entity** and **View** remain untouched.

---

## 📄 Documentation Links
*   [Freezed Code Gen Guide](FREEZED_GUIDE.md)
*   [Sizing & Design Tokens](lib/core/utils/app_sizes.dart)
