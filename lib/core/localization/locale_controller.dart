// ──────────────────────────────────────────────────────────────
// lib/core/localization/locale_controller.dart
// PURPOSE : Riverpod controller that manages the active locale
//           and persists the selection to KvStore.
//
// HOW TO ADD A LANGUAGE:
//   1. Create a new ARB file (e.g. app_hi.arb).
//   2. Add the Locale to [supportedLocales].
//   3. Provide translations.
// ──────────────────────────────────────────────────────────────

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../storage/kv_store.dart';

/// All locales the app supports.
const supportedLocales = [Locale('en'), Locale('bn')];

/// The currently selected [Locale].
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._ref) : super(supportedLocales.first) {
    _load();
  }

  final Ref _ref;

  void _load() {
    try {
      final saved = _ref.read(kvStoreProvider).savedLocale;
      if (saved != null) {
        final match = supportedLocales.firstWhere(
          (l) => l.languageCode == saved,
          orElse: () => supportedLocales.first,
        );
        state = match;
      }
    } catch (_) {
      // KvStore may not be ready yet – keep default.
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _ref.read(kvStoreProvider).saveLocale(locale.languageCode);
  }
}
