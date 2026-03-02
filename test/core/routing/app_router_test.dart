import 'package:flutter_test/flutter_test.dart';
import 'package:enyx_starter/core/routing/app_router.dart';

void main() {
  group('appRedirectLogic', () {
    test('redirects to missing-keys when config is missing', () {
      final redirect = appRedirectLogic(
        hasSupabaseKeys: false,
        isLoggedIn: false,
        matchedLocation: AppRoutes.home,
      );

      expect(redirect, AppRoutes.missingKeys);
    });

    test('redirects unauthenticated users to login', () {
      final redirect = appRedirectLogic(
        hasSupabaseKeys: true,
        isLoggedIn: false,
        matchedLocation: AppRoutes.home,
      );

      expect(redirect, AppRoutes.login);
    });

    test('redirects authenticated users away from auth pages', () {
      final redirect = appRedirectLogic(
        hasSupabaseKeys: true,
        isLoggedIn: true,
        matchedLocation: AppRoutes.login,
      );

      expect(redirect, AppRoutes.home);
    });

    test('returns null when no redirect is needed', () {
      final redirect = appRedirectLogic(
        hasSupabaseKeys: true,
        isLoggedIn: true,
        matchedLocation: AppRoutes.settings,
      );

      expect(redirect, isNull);
    });
  });
}
