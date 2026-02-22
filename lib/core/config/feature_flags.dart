// ──────────────────────────────────────────────────────────────
// lib/core/config/feature_flags.dart
// PURPOSE : Global boolean feature-flags exposed via Riverpod.
//           Acts as the single source of truth that all UI and
//           service layers read to decide what to show/enable.
//
// HOW TO EXTEND:
//   1. Add a new bool field here.
//   2. Read it wherever needed via `ref.watch(featureFlagsProvider)`.
//   3. For remote config, fetch from Supabase / Firebase and call
//      `ref.read(featureFlagsProvider.notifier).state = updated;`.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/legacy.dart';

/// Immutable flags class – replace values via copyWith for remote-config.
class FeatureFlags {
  const FeatureFlags({
    this.enableIap = false,
    this.enableGoogleLogin = true,
    this.enableAppleLogin = true,
    this.enableEmailPasswordLogin = true,
    this.enableSocialLogin = true,
    this.enableRealtime = false,
    this.enableCrashReporting = false,
    this.enableAnalytics = false,
  });

  /// Master switch for In-App Purchases.
  /// When false, IapService is a noop and paywall UI is hidden.
  final bool enableIap;

  /// Allow Google OAuth login (also requires [enableSocialLogin] = true).
  final bool enableGoogleLogin;

  /// Allow Apple OAuth login (also requires [enableSocialLogin] = true).
  final bool enableAppleLogin;

  /// Allow email/password auth.
  final bool enableEmailPasswordLogin;

  /// Master switch for social login (Google + Apple).
  /// When false, ALL social buttons are hidden and calls are blocked.
  final bool enableSocialLogin;

  /// Opt-in for Supabase Realtime subscriptions (future use).
  final bool enableRealtime;

  /// Hook for Sentry / Firebase Crashlytics.
  final bool enableCrashReporting;

  /// Hook for Firebase Analytics / Mixpanel / PostHog.
  final bool enableAnalytics;

  // Convenience getters ────────────────────────────────────────
  bool get isGoogleLoginVisible => enableSocialLogin && enableGoogleLogin;
  bool get isAppleLoginVisible => enableSocialLogin && enableAppleLogin;

  FeatureFlags copyWith({
    bool? enableIap,
    bool? enableGoogleLogin,
    bool? enableAppleLogin,
    bool? enableEmailPasswordLogin,
    bool? enableSocialLogin,
    bool? enableRealtime,
    bool? enableCrashReporting,
    bool? enableAnalytics,
  }) {
    return FeatureFlags(
      enableIap: enableIap ?? this.enableIap,
      enableGoogleLogin: enableGoogleLogin ?? this.enableGoogleLogin,
      enableAppleLogin: enableAppleLogin ?? this.enableAppleLogin,
      enableEmailPasswordLogin:
          enableEmailPasswordLogin ?? this.enableEmailPasswordLogin,
      enableSocialLogin: enableSocialLogin ?? this.enableSocialLogin,
      enableRealtime: enableRealtime ?? this.enableRealtime,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
    );
  }
}

/// Global feature-flags provider.
///
/// To override at runtime (e.g. from remote config):
/// ```dart
/// ref.read(featureFlagsProvider.notifier).state = flags.copyWith(enableIap: true);
/// ```
final featureFlagsProvider = StateProvider<FeatureFlags>(
  (ref) => const FeatureFlags(),
);
