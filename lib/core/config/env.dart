import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration populated from `.env` only.
class Env {
  const Env._();

  static String _safeGet(String key, {String fallback = ''}) {
    try {
      return dotenv.get(key, fallback: fallback);
    } catch (_) {
      return fallback;
    }
  }

  static String _safeEnv(String key, {String fallback = ''}) {
    try {
      return dotenv.env[key] ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  // ── Flavor ────────────────────────────────────────────────
  static String get flavor => _safeGet('FLAVOR', fallback: 'dev');

  static bool get isDev => flavor == 'dev';
  static bool get isStage => flavor == 'stage';
  static bool get isProd => flavor == 'prod';

  // ── Supabase ──────────────────────────────────────────────
  static String get supabaseUrl => _safeGet('SUPABASE_URL');

  static String get supabaseAnonKey => _safeGet('SUPABASE_ANON_KEY');

  static bool get hasSupabaseKeys =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // ── API Configuration ─────────────────────────────────────
  static String get apiBaseUrl =>
      _safeEnv('BASE_URL', fallback: _safeEnv('API_BASE_URL'));

  static String get baseUrlWeb => _safeEnv('BASE_URL_WEB');

  // ── App Links ─────────────────────────────────────────────
  static String get androidAppLink => _safeEnv('ANDROID_APP_LINK');

  static String get iosAppLink => _safeEnv('IOS_APP_LINK');

  /// OAuth redirect URI used by Supabase social sign-in.
  /// Example: com.enyx.starter://login-callback
  static String get oauthRedirectUrl => _safeEnv(
    'OAUTH_REDIRECT_URL',
    fallback: 'com.enyx.starter://login-callback',
  );

  // ── Logging ───────────────────────────────────────────────
  static bool get enableHttpLogs => !isProd;

  // ── Display helpers ───────────────────────────────────────
  static String get appNameSuffix {
    switch (flavor) {
      case 'stage':
        return ' [STG]';
      case 'dev':
        return ' [DEV]';
      default:
        return '';
    }
  }
}
