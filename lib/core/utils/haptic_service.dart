import 'package:flutter/services.dart';

/// A centralized service for haptic feedback to ensure consistent tactile feel.
abstract final class HapticService {
  /// Light impact for minor feedback.
  static Future<void> lightImpact() => HapticFeedback.lightImpact();

  /// Medium impact for standard actions.
  static Future<void> mediumImpact() => HapticFeedback.mediumImpact();

  /// Heavy impact for critical actions.
  static Future<void> heavyImpact() => HapticFeedback.heavyImpact();

  /// Selection click for scrolling or toggling.
  static Future<void> selectionClick() => HapticFeedback.selectionClick();

  /// Vibration for general alerts.
  static Future<void> vibrate() => HapticFeedback.vibrate();
}
