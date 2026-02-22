// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Enyx Starter';

  @override
  String get login => 'Log In';

  @override
  String get register => 'Register';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signOut => 'Sign Out';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log In';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent =>
      'A password-reset link has been sent to your email.';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get typography => 'Typography';

  @override
  String get authOptions => 'Authentication Options';

  @override
  String get socialLoginEnabled => 'Social Login';

  @override
  String get googleLoginEnabled => 'Google Login';

  @override
  String get appleLoginEnabled => 'Apple Login';

  @override
  String get emailPasswordEnabled => 'Email / Password';

  @override
  String get iapEnabled => 'In-App Purchases';

  @override
  String get appFlavor => 'App Flavor';

  @override
  String get enabled => 'enabled';

  @override
  String get disabled => 'disabled';

  @override
  String get offlineBanner => 'You are offline. Some features are unavailable.';

  @override
  String get offlineActionBlocked =>
      'This action requires an internet connection.';

  @override
  String get missingKeysTitle => 'Configuration Required';

  @override
  String get missingKeysBody =>
      'Supabase URL and/or Anon Key are not set.\n\nPass them via --dart-define:\n  --dart-define=SUPABASE_URL=https://xxx.supabase.co\n  --dart-define=SUPABASE_ANON_KEY=your-anon-key';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'Nothing here yet.';

  @override
  String get unknownError => 'Something went wrong. Please try again.';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }
}
