// ──────────────────────────────────────────────────────────────
// lib/core/theme/theme_packs.dart
// PURPOSE : Concrete theme pack definitions.
//           Each pack maps design tokens ➜ Flutter ThemeData.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import '../utils/app_sizes.dart';
import 'tokens.dart';

/// Registry of available theme packs.
final Map<String, ThemePack> themePacks = {
  // 'glass_light': ThemePack(
  //   label: 'Glass Light',
  //   cupertinoBuilder: _glassLightCupertino,
  // ),
  'glass_dark': ThemePack(
    label: 'Glass Dark',
    cupertinoBuilder: _glassDarkCupertino,
  ),
  // 'emerald': ThemePack(label: 'Emerald', cupertinoBuilder: _emeraldCupertino),
};

class ThemePack {
  const ThemePack({required this.label, required this.cupertinoBuilder});
  final String label;
  final CupertinoThemeData Function(String? fontFamily) cupertinoBuilder;
}

// ── Glass Light ──────────────────────────────────────────────
// const _glassLightColors = AppColorTokens(
//   primary: Color(0xFF6C63FF),
//   onPrimary: Colors.white,
//   secondary: Color(0xFF6C63FF),
//   surface: Color(0xFFF5F5F7),
//   onSurface: Color(0xFF1D1D1F),
//   background: Color(0xFFFFFFFF),
//   onBackground: Color(0xFF1D1D1F),
//   error: Color(0xFFE53935),
//   onError: Colors.white,
//   card: Color(0xFFFFFFFF),
//   divider: Color(0xFFE0E0E0),
//   disabled: Color(0xFFBDBDBD),
//   shadow: Color(0x1A000000),
//   success: Color(0xFF43A047),
// );

// CupertinoThemeData _glassLightCupertino(String? fontFamily) =>
//     _buildCupertinoTheme(_glassLightColors, Brightness.light, fontFamily);

// ── Glass Dark ───────────────────────────────────────────────
const _glassDarkColors = AppColorTokens(
  primary: Color(0xFF7B73FF),
  onPrimary: Colors.white,
  secondary: Color(0xFFFF7597),
  surface: Color(0xFF1E1E2C),
  onSurface: Color(0xFFE8E8ED),
  background: Color(0xFF121218),
  onBackground: Color(0xFFE8E8ED),
  error: Color(0xFFEF5350),
  onError: Colors.white,
  card: Color(0xFF2A2A3C),
  divider: Color(0xFF3A3A4C),
  disabled: Color(0xFF5A5A6C),
  shadow: Color(0x33000000),
  success: Color(0xFF66BB6A),
);

CupertinoThemeData _glassDarkCupertino(String? fontFamily) =>
    _buildCupertinoTheme(_glassDarkColors, Brightness.dark, fontFamily);

// ── Emerald ──────────────────────────────────────────────────
// const _emeraldColors = AppColorTokens(
//   primary: Color(0xFF00C853),
//   onPrimary: Colors.white,
//   secondary: Color(0xFF00B0FF),
//   surface: Color(0xFF1B2631),
//   onSurface: Color(0xFFECF0F1),
//   background: Color(0xFF0D1B2A),
//   onBackground: Color(0xFFECF0F1),
//   error: Color(0xFFFF5252),
//   onError: Colors.white,
//   card: Color(0xFF1E3044),
//   divider: Color(0xFF2C3E50),
//   disabled: Color(0xFF546E7A),
//   shadow: Color(0x33000000),
//   success: Color(0xFF00E676),
// );

// CupertinoThemeData _emeraldCupertino(String? fontFamily) =>
//     _buildCupertinoTheme(_emeraldColors, Brightness.dark, fontFamily);

// ── Builders ──────────────────────────────────────────────────

CupertinoThemeData _buildCupertinoTheme(
  AppColorTokens c,
  Brightness brightness,
  String? fontFamily,
) {
  return CupertinoThemeData(
    brightness: brightness,
    primaryColor: c.primary,
    scaffoldBackgroundColor: c.background,
    barBackgroundColor: c.surface,
    textTheme: CupertinoTextThemeData(
      primaryColor: c.primary,
      textStyle: TextStyle(
        color: c.onBackground,
        fontSize: AppSizes.bodySize,
        fontFamily: fontFamily,
      ),
      navActionTextStyle: TextStyle(
        color: c.primary,
        fontSize: AppSizes.bodySize + 1,
        fontFamily: fontFamily,
      ),
      navTitleTextStyle: TextStyle(
        color: c.onSurface,
        fontSize: AppSizes.bodySize + 1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      ),
      navLargeTitleTextStyle: TextStyle(
        color: c.onSurface,
        fontSize: AppSizes.titleSize,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
    ),
  );
}
