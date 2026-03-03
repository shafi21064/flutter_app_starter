import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';

import 'app_fonts.dart';
import 'theme_controller.dart';
import 'theme_packs.dart';

/// Unified app theme state so Cupertino, Material and Liquid Glass
/// stay in sync for theme + font changes.
class AppThemeState {
  const AppThemeState({
    required this.cupertino,
    required this.material,
    required this.liquid,
    required this.fontFamily,
    required this.brightness,
  });

  final CupertinoThemeData cupertino;
  final ThemeData material;
  final LiquidGlassTheme liquid;
  final String? fontFamily;
  final Brightness brightness;
}

final appThemeStateProvider = Provider<AppThemeState>((ref) {
  final themeKey = ref.watch(themeKeyProvider);
  final fontKey = ref.watch(fontFamilyProvider);

  final pack = themePacks[themeKey] ?? themePacks.values.first;
  final fontFamily = AppTypography.getFontFamily(fontKey);
  final cupertinoTheme = pack.cupertinoBuilder(fontFamily);
  final brightness = cupertinoTheme.brightness ?? Brightness.dark;

  final materialTheme = ThemeData(
    brightness: brightness,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: cupertinoTheme.primaryColor,
      brightness: brightness,
    ),
  );

  final liquidTheme = brightness == Brightness.dark
      ? LiquidGlassTheme.dark(brandTint: cupertinoTheme.primaryColor)
      : LiquidGlassTheme.light(brandTint: cupertinoTheme.primaryColor);

  return AppThemeState(
    cupertino: cupertinoTheme,
    material: materialTheme,
    liquid: liquidTheme,
    fontFamily: fontFamily,
    brightness: brightness,
  );
});
