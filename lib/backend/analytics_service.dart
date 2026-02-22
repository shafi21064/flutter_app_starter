// ──────────────────────────────────────────────────────────────
// lib/backend/analytics_service.dart
// PURPOSE : Analytics interface with a noop default implementation.
//           Controlled by the enableAnalytics feature flag.
//
// WHERE TO INTEGRATE LATER:
//   1. Add firebase_analytics, mixpanel_flutter, or posthog_flutter
//      to pubspec.yaml.
//   2. Create a concrete subclass of AnalyticsService.
//   3. Override the provider in main.dart when enableAnalytics = true.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/feature_flags.dart';
import '../core/logging/log.dart';

/// Riverpod provider – override with a real implementation when ready.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final flags = ref.watch(featureFlagsProvider);
  return AnalyticsService(enabled: flags.enableAnalytics);
});

/// Noop analytics service.
/// Replace with Firebase Analytics / Mixpanel / PostHog when ready.
class AnalyticsService {
  AnalyticsService({required this.enabled});
  final bool enabled;

  /// Log a named event with optional parameters.
  void logEvent(String name, [Map<String, Object>? params]) {
    if (!enabled) return;
    // TODO: Forward to your analytics SDK.
    Log.d('Analytics: $name ${params ?? ''}');
  }

  /// Identify the current user.
  void identify(String userId) {
    if (!enabled) return;
    // TODO: Forward to your analytics SDK.
    Log.d('Analytics: identify $userId');
  }

  /// Track screen views.
  void screen(String name) {
    if (!enabled) return;
    Log.d('Analytics: screen $name');
  }
}
