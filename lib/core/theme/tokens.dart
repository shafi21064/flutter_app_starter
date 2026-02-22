// ──────────────────────────────────────────────────────────────
// lib/core/theme/tokens.dart
// PURPOSE : Design tokens – semantic colours, spacing scale,
//           radius scale, glass blur values. All theme packs
//           implement this contract.
//
// HOW TO EXTEND:
//   Add new tokens here and supply values in each ThemePack.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Semantic colour tokens that every theme pack must provide.
class AppColorTokens {
  const AppColorTokens({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.onError,
    required this.card,
    required this.divider,
    required this.disabled,
    required this.shadow,
    required this.success,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color onBackground;
  final Color error;
  final Color onError;
  final Color card;
  final Color divider;
  final Color disabled;
  final Color shadow;
  final Color success;
}

/// Spacing scale (use multiples of 4).
class AppSpacing {
  const AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Radius scale.
class AppRadius {
  const AppRadius._();
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 9999;
}

/// Glass / blur tokens used by the glassmorphism theme packs.
class GlassTokens {
  const GlassTokens({
    this.blurSigma = 10,
    this.opacity = 0.15,
    this.borderOpacity = 0.2,
  });

  final double blurSigma;
  final double opacity;
  final double borderOpacity;
}
