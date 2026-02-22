// ──────────────────────────────────────────────────────────────
// lib/core/storage/kv_store.dart
// PURPOSE : Wrapper around SharedPreferences for NON-SENSITIVE
//           key-value storage (theme pref, locale, onboarding
//           flags, etc.).
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod provider – override in ProviderScope after init.
final kvStoreProvider = Provider<KvStore>((ref) {
  // Will be overridden in main.dart after SharedPreferences.getInstance().
  throw UnimplementedError('kvStoreProvider must be overridden at startup');
});

/// Lightweight wrapper around [SharedPreferences].
class KvStore {
  KvStore(this._prefs);
  final SharedPreferences _prefs;

  // ── Generic accessors ──────────────────────────────────────
  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);

  // ── App-specific keys ──────────────────────────────────────
  static const _kTheme = 'app_theme';
  static const _kLocale = 'app_locale';
  static const _kFontFamily = 'app_font_family';

  String? get savedThemeKey => getString(_kTheme);
  Future<bool> saveThemeKey(String key) => setString(_kTheme, key);

  String? get savedLocale => getString(_kLocale);
  Future<bool> saveLocale(String code) => setString(_kLocale, code);

  String? get savedFontFamily => getString(_kFontFamily);
  Future<bool> saveFontFamily(String family) => setString(_kFontFamily, family);
}
