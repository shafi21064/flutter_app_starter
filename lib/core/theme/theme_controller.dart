// ──────────────────────────────────────────────────────────────
// lib/core/theme/theme_controller.dart
// PURPOSE : Riverpod controller that manages the active theme,
//           font family, and persists the selection to KvStore.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../storage/kv_store.dart';
import 'theme_packs.dart';
import 'app_fonts.dart';

/// The currently active [CupertinoThemeData], rebuilt when theme or font changes.
final themeDataProvider = Provider<CupertinoThemeData>((ref) {
  final key = ref.watch(themeKeyProvider);
  final fontKey = ref.watch(fontFamilyProvider);

  final pack = themePacks[key] ?? themePacks.values.first;
  final fontFamily = AppTypography.getFontFamily(fontKey);

  return pack.cupertinoBuilder(fontFamily);
});

/// Persisted theme key.
final themeKeyProvider = StateNotifierProvider<ThemeKeyNotifier, String>((ref) {
  return ThemeKeyNotifier(ref);
});

class ThemeKeyNotifier extends StateNotifier<String> {
  ThemeKeyNotifier(this._ref) : super(_defaultKey) {
    _load();
  }

  static const _defaultKey = 'glass_light';
  final Ref _ref;

  void _load() {
    try {
      final saved = _ref.read(kvStoreProvider).savedThemeKey;
      if (saved != null && themePacks.containsKey(saved)) {
        state = saved;
      }
    } catch (_) {
      // KvStore may not be ready yet.
    }
  }

  Future<void> setTheme(String key) async {
    if (!themePacks.containsKey(key)) return;
    state = key;
    await _ref.read(kvStoreProvider).saveThemeKey(key);
  }
}

/// Persisted font family key.
final fontFamilyProvider = StateNotifierProvider<FontFamilyNotifier, String>((
  ref,
) {
  return FontFamilyNotifier(ref);
});

class FontFamilyNotifier extends StateNotifier<String> {
  FontFamilyNotifier(this._ref) : super(_defaultKey) {
    _load();
  }

  static const _defaultKey = 'inter';
  final Ref _ref;

  void _load() {
    try {
      final saved = _ref.read(kvStoreProvider).savedFontFamily;
      if (saved != null && appFonts.containsKey(saved)) {
        state = saved;
      }
    } catch (_) {
      // KvStore may not be ready yet.
    }
  }

  Future<void> setFontFamily(String key) async {
    if (!appFonts.containsKey(key)) return;
    state = key;
    await _ref.read(kvStoreProvider).saveFontFamily(key);
  }
}
