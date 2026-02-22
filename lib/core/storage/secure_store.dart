// ──────────────────────────────────────────────────────────────
// lib/core/storage/secure_store.dart
// PURPOSE : Wrapper around FlutterSecureStorage for SENSITIVE
//           data (tokens, secrets, PII).
//
// WHAT BELONGS HERE:
//   ✓ Refresh tokens (if not managed by Supabase SDK)
//   ✓ Encryption keys
//   ✓ User PII that must be encrypted at rest
//   ✗ Theme preferences, locale → use KvStore instead
//
// HOW TO EXTEND:
//   Add typed methods for new secret keys.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provider for [SecureStore].
final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

/// Thin wrapper around [FlutterSecureStorage].
class SecureStore {
  // Android: uses EncryptedSharedPreferences.
  // iOS: uses Keychain.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();
}
