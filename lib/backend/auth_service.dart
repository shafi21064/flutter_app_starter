// ──────────────────────────────────────────────────────────────
// lib/backend/auth_service.dart
// PURPOSE : Wraps Supabase Auth – email/password + social OAuth.
//           All methods return Result<T> and respect feature flags.
//
// PLATFORM SETUP NOTES:
//
// ── Google OAuth ────────────────────────────────────────────
// iOS:
//   1. Add your reversed Google client ID as a URL scheme in
//      ios/Runner/Info.plist → CFBundleURLTypes.
//   2. Set the redirect URL in Supabase dashboard →
//      Authentication → Providers → Google.
//
// Android:
//   1. Add intent filter in android/app/src/main/AndroidManifest.xml:
//      <intent-filter>
//        <action android:name="android.intent.action.VIEW"/>
//        <category android:name="android.intent.category.DEFAULT"/>
//        <category android:name="android.intent.category.BROWSABLE"/>
//        <data android:scheme="com.enyx.starter"
//              android:host="login-callback"/>
//      </intent-filter>
//   2. Register your SHA-1 in the Google Cloud console.
//
// ── Apple OAuth ─────────────────────────────────────────────
// iOS:
//   1. Enable "Sign in with Apple" capability in Xcode.
//   2. Register a Services ID at developer.apple.com.
//   3. Set the redirect URL in Supabase dashboard →
//      Authentication → Providers → Apple.
//
// Android:
//   Apple sign-in on Android opens a web-based flow via Supabase
//   redirect, so no additional native setup is needed.
//
// ── Bundle / Package names ──────────────────────────────────
//   iOS bundle ID : com.enyx.starter  (set in Xcode)
//   Android pkg   : com.enyx.starter  (set in build.gradle)
//   Make sure they match what's registered in OAuth provider
//   consoles and Supabase dashboard.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/env.dart';
import '../core/config/feature_flags.dart';
import '../core/connectivity/connectivity_controller.dart';
import '../core/logging/log.dart';
import '../core/result/result.dart';

/// Riverpod provider for [AuthService].
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

/// Convenience provider that exposes the current Supabase [User] or null.
final currentUserProvider = StreamProvider<User?>((ref) {
  if (!Env.hasSupabaseKeys) return Stream.value(null);
  return Supabase.instance.client.auth.onAuthStateChange
      .map((event) => event.session?.user);
});

class AuthService {
  AuthService(this._ref);
  final Ref _ref;

  GoTrueClient get _auth => Supabase.instance.client.auth;

  // ── Helpers ────────────────────────────────────────────────

  /// Returns a Failure if the device is offline.
  Failure<T>? _offlineGuard<T>() {
    final online = _ref.read(connectivityProvider);
    if (!online) {
      return const Failure(
        'No internet connection. Please try again when online.',
        kind: FailureKind.offline,
      );
    }
    return null;
  }

  // ── Email / Password ──────────────────────────────────────

  Future<Result<User>> signUp({
    required String email,
    required String password,
  }) async {
    final off = _offlineGuard<User>();
    if (off != null) return off;

    final flags = _ref.read(featureFlagsProvider);
    if (!flags.enableEmailPasswordLogin) {
      return const Failure('Email/password login is disabled',
          kind: FailureKind.featureDisabled);
    }

    try {
      final res = await _auth.signUp(
        email: email,
        password: password,
        // Ensures email confirmation link redirects back to the app.
        emailRedirectTo: Env.oauthRedirectUrl,
      );
      if (res.user == null) {
        return const Failure('Sign-up failed – no user returned',
            kind: FailureKind.auth);
      }
      Log.i('User signed up: ${res.user!.id}');
      return Success(res.user!);
    } on AuthException catch (e) {
      Log.w('Sign-up error', error: e);
      return Failure(e.message, kind: FailureKind.auth, exception: e);
    } catch (e, st) {
      Log.e('Unexpected sign-up error', error: e, stack: st);
      return Failure('An unexpected error occurred',
          kind: FailureKind.unknown, exception: e);
    }
  }

  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) async {
    final off = _offlineGuard<User>();
    if (off != null) return off;

    final flags = _ref.read(featureFlagsProvider);
    if (!flags.enableEmailPasswordLogin) {
      return const Failure('Email/password login is disabled',
          kind: FailureKind.featureDisabled);
    }

    try {
      final res =
          await _auth.signInWithPassword(email: email, password: password);
      if (res.user == null) {
        return const Failure('Login failed – invalid credentials',
            kind: FailureKind.auth);
      }
      Log.i('User signed in: ${res.user!.id}');
      return Success(res.user!);
    } on AuthException catch (e) {
      Log.w('Sign-in error', error: e);
      return Failure(e.message, kind: FailureKind.auth, exception: e);
    } catch (e, st) {
      Log.e('Unexpected sign-in error', error: e, stack: st);
      return Failure('An unexpected error occurred',
          kind: FailureKind.unknown, exception: e);
    }
  }

  Future<Result<void>> resetPassword(String email) async {
    final off = _offlineGuard<void>();
    if (off != null) return off;

    try {
      await _auth.resetPasswordForEmail(
        email,
        // Ensures password reset flow redirects back to the app.
        redirectTo: Env.oauthRedirectUrl,
      );
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(e.message, kind: FailureKind.auth, exception: e);
    } catch (e, st) {
      Log.e('Password reset error', error: e, stack: st);
      return Failure('Could not send reset email',
          kind: FailureKind.unknown, exception: e);
    }
  }

  // ── Social / OAuth ────────────────────────────────────────

  Future<Result<void>> signInWithGoogle() async {
    return _socialSignIn(OAuthProvider.google, 'Google');
  }

  Future<Result<void>> signInWithApple() async {
    return _socialSignIn(OAuthProvider.apple, 'Apple');
  }

  Future<Result<void>> _socialSignIn(
      OAuthProvider provider, String label) async {
    final off = _offlineGuard<void>();
    if (off != null) return off;

    final flags = _ref.read(featureFlagsProvider);
    if (!flags.enableSocialLogin) {
      return const Failure('Social login is disabled',
          kind: FailureKind.featureDisabled);
    }
    if (provider == OAuthProvider.google && !flags.enableGoogleLogin) {
      return const Failure('Google login is disabled',
          kind: FailureKind.featureDisabled);
    }
    if (provider == OAuthProvider.apple && !flags.enableAppleLogin) {
      return const Failure('Apple login is disabled',
          kind: FailureKind.featureDisabled);
    }

    try {
      await _auth.signInWithOAuth(
        provider,
        // The redirect URL must match the deep-link scheme configured
        // in Supabase dashboard and your platform manifests/plist.
        redirectTo: Env.oauthRedirectUrl,
      );
      return const Success(null);
    } catch (e, st) {
      Log.e('$label OAuth error', error: e, stack: st);
      return Failure('$label sign-in failed',
          kind: FailureKind.auth, exception: e);
    }
  }

  // ── Sign out ──────────────────────────────────────────────

  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      Log.i('User signed out');
      return const Success(null);
    } catch (e, st) {
      Log.e('Sign-out error', error: e, stack: st);
      return Failure('Failed to sign out',
          kind: FailureKind.unknown, exception: e);
    }
  }
}
