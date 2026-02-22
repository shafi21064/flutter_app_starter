// ──────────────────────────────────────────────────────────────
// lib/features/settings/presentation/controller/settings_controller.dart
// PURPOSE : Exposes theme, font, and locale switching plus
//           read-only feature-flag summaries for the SettingsView.
// ──────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_controller.dart';
import '../../../../core/localization/locale_controller.dart';

/// Convenience controller that groups settings actions.
class SettingsController {
  SettingsController(this._ref);
  final Ref _ref;

  Future<void> setTheme(String key) async {
    await _ref.read(themeKeyProvider.notifier).setTheme(key);
  }

  Future<void> setFontFamily(String key) async {
    await _ref.read(fontFamilyProvider.notifier).setFontFamily(key);
  }

  Future<void> setLocale(Locale locale) async {
    await _ref.read(localeProvider.notifier).setLocale(locale);
  }
}

final settingsControllerProvider = Provider<SettingsController>((ref) {
  return SettingsController(ref);
});
