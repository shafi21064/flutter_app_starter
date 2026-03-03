import 'package:enyx_starter/core/routing/app_routes.dart';
import 'package:enyx_starter/core/routing/app_tabs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('appTabSpecs routes stay unique and in expected order', () {
    final routes = appTabSpecs.map((e) => e.route).toList();
    expect(routes, [AppRoutes.home, AppRoutes.profile, AppRoutes.settings]);
    expect(routes.toSet().length, routes.length);
  });
}
