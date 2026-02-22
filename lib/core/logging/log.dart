// ──────────────────────────────────────────────────────────────
// lib/core/logging/log.dart
// PURPOSE : App-wide logger singleton using the `logger` package.
//           Wraps Logger so you can swap implementations later.
//
// USAGE:
//   import 'package:enyx_starter/core/logging/log.dart';
//   Log.d('debug message');
//   Log.e('error', error: someException);
//
// HOW TO EXTEND:
//   - Pipe logs to Crashlytics/Sentry by adding an output filter.
// ──────────────────────────────────────────────────────────────

import 'package:logger/logger.dart';

/// Thin wrapper around [Logger] for consistent, filterable logging.
class Log {
  Log._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      noBoxingByDefault: true,
    ),
  );

  /// Verbose / trace.
  static void t(String message) => _logger.t(message);

  /// Debug.
  static void d(String message) => _logger.d(message);

  /// Info.
  static void i(String message) => _logger.i(message);

  /// Warning.
  static void w(String message, {Object? error}) =>
      _logger.w(message, error: error);

  /// Error.
  static void e(String message, {Object? error, StackTrace? stack}) =>
      _logger.e(message, error: error, stackTrace: stack);

  /// Fatal.
  static void f(String message, {Object? error, StackTrace? stack}) =>
      _logger.f(message, error: error, stackTrace: stack);
}
