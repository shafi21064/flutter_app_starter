import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Read from dart-define at build time.
/// These are used primarily for Web builds where .env is not easily accessible at runtime.
const String _flavorDefine = String.fromEnvironment('FLAVOR');
const String _baseUrlDefine = String.fromEnvironment('API_BASE_URL');
const String _baseUrlWebDefine = String.fromEnvironment('BASE_URL_WEB');
const String _androidAppLinkDefine = String.fromEnvironment('ANDROID_APP_LINK');
const String _iosAppLinkDefine = String.fromEnvironment('IOS_APP_LINK');
const String _supabaseUrlDefine = String.fromEnvironment('SUPABASE_URL');
const String _supabaseAnonDefine = String.fromEnvironment('SUPABASE_ANON_KEY');
const String _oauthRedirectDefine = String.fromEnvironment('OAUTH_REDIRECT_URL');

/// Environment configuration populated from `--dart-define` or `.env`.
///
/// Precedence:
/// - `--dart-define` (all platforms)
/// - `.env` fallback (mobile/desktop)
/// - empty/default fallback
class Env {
  const Env._();

  static String _definedOr(String defineValue, String fallback) {
    if (defineValue.isNotEmpty) return defineValue;
    return fallback;
  }

  // ── Flavor ────────────────────────────────────────────────
  static String get flavor {
    if (kIsWeb) return _flavorDefine.isNotEmpty ? _flavorDefine : 'dev';
    return _definedOr(_flavorDefine, dotenv.get('FLAVOR', fallback: 'dev'));
  }

  static bool get isDev => flavor == 'dev';
  static bool get isStage => flavor == 'stage';
  static bool get isProd => flavor == 'prod';

  // ── Supabase ──────────────────────────────────────────────
  static String get supabaseUrl {
    if (kIsWeb) return _supabaseUrlDefine.isNotEmpty ? _supabaseUrlDefine : '';
    return _definedOr(
      _supabaseUrlDefine,
      dotenv.get('SUPABASE_URL', fallback: ''),
    );
  }

  static String get supabaseAnonKey {
    if (kIsWeb) return _supabaseAnonDefine.isNotEmpty ? _supabaseAnonDefine : '';
    return _definedOr(
      _supabaseAnonDefine,
      dotenv.get('SUPABASE_ANON_KEY', fallback: ''),
    );
  }

  static bool get hasSupabaseKeys =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // ── API Configuration ─────────────────────────────────────
  static String get apiBaseUrl {
    if (kIsWeb) return _baseUrlDefine.isNotEmpty ? _baseUrlDefine : '';
    return _definedOr(
      _baseUrlDefine,
      dotenv.env['BASE_URL'] ?? dotenv.env['API_BASE_URL'] ?? '',
    );
  }

  static String get baseUrlWeb {
    if (kIsWeb) return _baseUrlWebDefine.isNotEmpty ? _baseUrlWebDefine : '';
    return dotenv.env['BASE_URL_WEB'] ?? '';
  }

  // ── App Links ─────────────────────────────────────────────
  static String get androidAppLink {
    if (kIsWeb && _androidAppLinkDefine.isNotEmpty) return _androidAppLinkDefine;
    return _definedOr(_androidAppLinkDefine, dotenv.env['ANDROID_APP_LINK'] ?? '');
  }

  static String get iosAppLink {
    if (kIsWeb && _iosAppLinkDefine.isNotEmpty) return _iosAppLinkDefine;
    return _definedOr(_iosAppLinkDefine, dotenv.env['IOS_APP_LINK'] ?? '');
  }

  /// OAuth redirect URI used by Supabase social sign-in.
  /// Example: com.enyx.starter://login-callback
  static String get oauthRedirectUrl {
    if (kIsWeb) {
      return _oauthRedirectDefine.isNotEmpty
          ? _oauthRedirectDefine
          : 'com.enyx.starter://login-callback';
    }
    return _definedOr(
      _oauthRedirectDefine,
      dotenv.env['OAUTH_REDIRECT_URL'] ?? 'com.enyx.starter://login-callback',
    );
  }

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
