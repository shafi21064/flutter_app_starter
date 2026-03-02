import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration populated from `.env` only.
class Env {
  const Env._();

  // ── Flavor ────────────────────────────────────────────────
  static String get flavor => dotenv.get('FLAVOR', fallback: 'dev');

  static bool get isDev => flavor == 'dev';
  static bool get isStage => flavor == 'stage';
  static bool get isProd => flavor == 'prod';

  // ── Supabase ──────────────────────────────────────────────
  static String get supabaseUrl => dotenv.get('SUPABASE_URL', fallback: '');

  static String get supabaseAnonKey =>
      dotenv.get('SUPABASE_ANON_KEY', fallback: '');

  static bool get hasSupabaseKeys =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // ── API Configuration ─────────────────────────────────────
  static String get apiBaseUrl =>
      dotenv.env['BASE_URL'] ?? dotenv.env['API_BASE_URL'] ?? '';

  static String get baseUrlWeb => dotenv.env['BASE_URL_WEB'] ?? '';

  // ── App Links ─────────────────────────────────────────────
  static String get androidAppLink => dotenv.env['ANDROID_APP_LINK'] ?? '';

  static String get iosAppLink => dotenv.env['IOS_APP_LINK'] ?? '';

  /// OAuth redirect URI used by Supabase social sign-in.
  /// Example: com.enyx.starter://login-callback
  static String get oauthRedirectUrl =>
      dotenv.env['OAUTH_REDIRECT_URL'] ?? 'com.enyx.starter://login-callback';

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
