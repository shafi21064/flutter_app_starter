// ──────────────────────────────────────────────────────────────
// lib/backend/crash_reporting_service.dart
// PURPOSE : Crash reporting interface with a noop default.
//           Controlled by the enableCrashReporting feature flag.
//
// WHERE TO INTEGRATE LATER:
//   1. Add sentry_flutter or firebase_crashlytics to pubspec.yaml.
//   2. Create a concrete subclass.
//   3. Override the provider when enableCrashReporting = true.
//   4. Wrap runApp in runZonedGuarded for global error capture.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/feature_flags.dart';
import '../core/logging/log.dart';

/// Riverpod provider – override with Sentry/Crashlytics when ready.
final crashReportingServiceProvider =
    Provider<CrashReportingService>((ref) {
  final flags = ref.watch(featureFlagsProvider);
  return CrashReportingService(enabled: flags.enableCrashReporting);
});

/// Noop crash reporting service.
class CrashReportingService {
  CrashReportingService({required this.enabled});
  final bool enabled;

  /// Report a non-fatal error.
  void recordError(Object error, StackTrace? stack, {bool fatal = false}) {
    if (!enabled) return;
    // TODO: Forward to Sentry / Crashlytics.
    Log.e('CrashReporting: ${fatal ? "FATAL" : "error"}',
        error: error, stack: stack);
  }

  /// Attach a user identifier for crash context.
  void setUser(String userId) {
    if (!enabled) return;
    Log.d('CrashReporting: setUser $userId');
  }

  /// Set a custom key-value pair for crash context.
  void setCustomKey(String key, String value) {
    if (!enabled) return;
    Log.d('CrashReporting: $key = $value');
  }
}
