// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_sizes.dart
// PURPOSE : Centralised sizing & spacing constants.
//           Includes a global scale variable for easy resizing.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/widgets.dart';

import 'package:enyx_starter/core/theme/tokens.dart';

abstract final class AppSizes {
  // ── Breakpoints ─────────────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  /// Scale is derived from the current view width.
  /// No mutable global state is required.
  static double get scale => _scaleForWidth(_currentLogicalWidth);

  @Deprecated('Scale is now computed automatically from current view width.')
  static void updateScale(double width) {}

  static double _scaleForWidth(double width) {
    if (width < mobileBreakpoint) return 1.0;
    if (width < tabletBreakpoint) return 1.2;
    return 1.4;
  }

  static double get _currentLogicalWidth {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    if (dispatcher.views.isEmpty) return mobileBreakpoint;
    final view = dispatcher.views.first;
    return view.physicalSize.width / view.devicePixelRatio;
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
  static double get captionSize => 12 * scale;
  static double get subheadingSize => 18 * scale;
  static double get headingSmSize => 22 * scale;

  // ── Component Specific ──────────────────────────────────────
  static double get loadingIndicatorSize => 20 * scale;
  static double get loadingStrokeWidth => 2 * scale;
  static double get avatarRadius => 40 * scale;
  static double get avatarSize => 80 * scale;

  // ── Radius ──────────────────────────────────────────────────
  static double get radiusSm => AppRadius.sm * scale;
  static double get radiusMd => AppRadius.md * scale;
  static double get radiusLg => AppRadius.lg * scale;
  static double get radiusXl => AppRadius.xl * scale;
}
