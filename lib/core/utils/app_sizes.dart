// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_sizes.dart
// PURPOSE : Centralised sizing & spacing constants.
//           Includes a global scale variable for easy resizing.
// ──────────────────────────────────────────────────────────────

import 'package:enyx_starter/core/theme/tokens.dart';

abstract final class AppSizes {
  /// Global scale factor for sizing.
  static double scale = 1.0;

  // ── Breakpoints ─────────────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  /// Updates the global scale based on screen width.
  static void updateScale(double width) {
    if (width < mobileBreakpoint) {
      scale = 1.0;
    } else if (width < tabletBreakpoint) {
      scale = 1.2; // Tablet scale
    } else {
      scale = 1.4; // Desktop/Laptop scale
    }
  }

  // ── Layout ──────────────────────────────────────────────────
  static double get pagePadding => AppSpacing.lg * scale;
  static double get formMaxWidth => 400 * scale;

  // ── Spacing (for Gap) ───────────────────────────────────────
  static double get spacingXs => AppSpacing.xs * scale;
  static double get spacingSm => AppSpacing.sm * scale;
  static double get spacingMd => AppSpacing.md * scale;
  static double get spacingLg => AppSpacing.lg * scale;
  static double get spacingXl => AppSpacing.xl * scale;
  static double get spacingXxl => AppSpacing.xxl * scale;

  // ── Icon sizes ──────────────────────────────────────────────
  static double get iconSm => 16 * scale;
  static double get iconMd => 24 * scale;
  static double get iconLg => 48 * scale;
  static double get iconXl => 64 * scale;

  // ── Typography ───────────────────────────────────────────────
  static double get titleSize => 24 * scale;
  static double get bodySize => 16 * scale;
  static double get labelSize => 14 * scale;
  static double get smallSize => 12 * scale;

  // ── Component Specific ──────────────────────────────────────
  static double get loadingIndicatorSize => 20 * scale;
  static double get loadingStrokeWidth => 2 * scale;

  // ── Radius ──────────────────────────────────────────────────
  static double get radiusSm => AppRadius.sm * scale;
  static double get radiusMd => AppRadius.md * scale;
  static double get radiusLg => AppRadius.lg * scale;
  static double get radiusXl => AppRadius.xl * scale;
}
