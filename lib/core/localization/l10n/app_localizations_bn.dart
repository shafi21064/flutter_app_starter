// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'এনিক্স স্টার্টার';

  @override
  String get home => 'হোম';

  @override
  String get login => 'লগ ইন';

  @override
  String get register => 'নিবন্ধন';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get resetPassword => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get fullName => 'পূর্ণ নাম';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get signInWithGoogle => 'গুগল দিয়ে সাইন ইন';

  @override
  String get signInWithApple => 'অ্যাপল দিয়ে সাইন ইন';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String get dontHaveAccount => 'অ্যাকাউন্ট নেই? নিবন্ধন করুন';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে? লগ ইন';

  @override
  String get sendResetLink => 'রিসেট লিংক পাঠান';

  @override
  String get resetLinkSent =>
      'একটি পাসওয়ার্ড রিসেট লিংক আপনার ইমেইলে পাঠানো হয়েছে।';

  @override
  String get verifyEmailAfterRegister =>
      'রেজিস্ট্রেশন সফল হয়েছে। লগইন করার আগে আপনার ইমেইলে গিয়ে অ্যাকাউন্ট ভেরিফাই করুন।';

  @override
  String get settings => 'সেটিংস';

  @override
  String get theme => 'থিম';

  @override
  String get language => 'ভাষা';

  @override
  String get typography => 'টাইপোগ্রাফি';

  @override
  String get authOptions => 'প্রমাণীকরণ বিকল্প';

  @override
  String get socialLoginEnabled => 'সোশ্যাল লগইন';

  @override
  String get googleLoginEnabled => 'গুগল লগইন';

  @override
  String get appleLoginEnabled => 'অ্যাপল লগইন';

  @override
  String get emailPasswordEnabled => 'ইমেইল / পাসওয়ার্ড';

  @override
  String get iapEnabled => 'ইন-অ্যাপ ক্রয়';

  @override
  String get appFlavor => 'অ্যাপ ফ্লেভার';

  @override
  String get enabled => 'সক্রিয়';

  @override
  String get disabled => 'নিষ্ক্রিয়';

  @override
  String get offlineBanner => 'আপনি অফলাইনে আছেন। কিছু ফিচার অনুপলব্ধ।';

  @override
  String get offlineActionBlocked => 'এই কাজটির জন্য ইন্টারনেট সংযোগ প্রয়োজন।';

  @override
  String get missingKeysTitle => 'কনফিগারেশন প্রয়োজন';

  @override
  String get missingKeysBody =>
      'Supabase URL এবং/অথবা Anon Key সেট করা নেই।\n\n.env ফাইলে সেট করুন:\n  SUPABASE_URL=https://xxx.supabase.co\n  SUPABASE_ANON_KEY=your-anon-key';

  @override
  String get retry => 'পুনরায় চেষ্টা';

  @override
  String get noData => 'এখানে এখনো কিছুই নেই।';

  @override
  String get unknownError => 'কিছু ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get defaultUserName => 'ইউজার';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get profileNoBio => 'এখনও বায়ো নেই';

  @override
  String get profileBioHeader => 'বায়ো';

  @override
  String get profileMissingUserId => 'ইউজার আইডি নেই';

  @override
  String errorWithMessage(String message) {
    return 'ত্রুটি: $message';
  }

  @override
  String get configureIapHint =>
      'feature_flags.dart বা remote config থেকে enableIap সেট করুন।';

  @override
  String get devTools => 'ডেভ টুলস';

  @override
  String get simulateOffline => 'অফলাইন সিমুলেট করুন';

  @override
  String get currentlyOnline => 'এখন অনলাইনে';

  @override
  String get currentlyOffline => 'এখন অফলাইনে';

  @override
  String welcomeUser(String name) {
    return 'স্বাগতম, $name!';
  }
}
