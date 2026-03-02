// ──────────────────────────────────────────────────────────────
// lib/core/routing/app_router.dart
// PURPOSE : GoRouter configuration with auth-aware redirects.
//
// ROUTING RULES:
//   1. If Supabase keys are missing → MissingKeysPage.
//   2. If user is not authenticated → /login (auth flow).
//   3. If user is authenticated → /home.
//   4. Settings available from /settings.
//
// HOW TO ADD A NEW ROUTE:
//   1. Create your page widget under features/<name>/presentation/view/.
//   2. Add a GoRoute below.
//   3. Optionally add a redirect guard.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../../features/auth/presentation/view/forgot_password_view.dart';
import '../../features/auth/presentation/view/login_view.dart';
import '../../features/auth/presentation/view/register_view.dart';
import '../../features/boot/presentation/view/missing_keys_view.dart';
import '../../features/home/presentation/view/home_view.dart';
import '../../features/profile/presentation/view/profile_view.dart';
import '../../features/settings/presentation/view/settings_view.dart';

/// Named route paths for type-safe navigation.
class AppRoutes {
  static const String missingKeys = '/missing-keys';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile/:userId';
  static const String settings = '/settings';

  static String profilePath(String userId) => '/profile/$userId';
}

/// GoRouter provider — watches auth state for reactive redirects.
final appRouterProvider = Provider<GoRouter>((ref) {
  // Rebuild router when auth state toggles.
  final authNotifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = Env.hasSupabaseKeys
          ? Supabase.instance.client.auth.currentSession != null
          : false;
      return appRedirectLogic(
        hasSupabaseKeys: Env.hasSupabaseKeys,
        isLoggedIn: isLoggedIn,
        matchedLocation: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.missingKeys,
        builder: (_, _) => const MissingKeysView(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginView()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterView(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordView(),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeView()),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, state) => ProfileView(
          userId: state.pathParameters['userId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsView(),
      ),
    ],
  );
});

String? appRedirectLogic({
  required bool hasSupabaseKeys,
  required bool isLoggedIn,
  required String matchedLocation,
}) {
  // 1. Missing Supabase keys → show config screen.
  if (!hasSupabaseKeys) {
    if (matchedLocation != AppRoutes.missingKeys) {
      return AppRoutes.missingKeys;
    }
    return null;
  }

  final isOnAuthPage = matchedLocation == AppRoutes.login ||
      matchedLocation == AppRoutes.register ||
      matchedLocation == AppRoutes.forgotPassword;

  // 2. Not logged in → redirect to login (unless already there).
  if (!isLoggedIn &&
      !isOnAuthPage &&
      matchedLocation != AppRoutes.missingKeys) {
    return AppRoutes.login;
  }

  // 3. Logged in but on auth page → redirect to home.
  if (isLoggedIn && isOnAuthPage) {
    return AppRoutes.home;
  }

  return null; // no redirect
}

/// Listenable that fires when the Supabase auth session changes,
/// causing GoRouter to re-evaluate its redirect logic.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(this._ref) {
    if (Env.hasSupabaseKeys) {
      Supabase.instance.client.auth.onAuthStateChange.listen((_) {
        notifyListeners();
      });
    }
  }

  // ignore: unused_field
  final Ref _ref;
}
