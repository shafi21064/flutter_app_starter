import 'package:flutter/cupertino.dart';

import '../localization/l10n/app_localizations.dart';
import 'app_routes.dart';

class AppTabSpec {
  const AppTabSpec({
    required this.route,
    required this.icon,
    required this.labelBuilder,
  });

  final String route;
  final IconData icon;
  final String Function(AppLocalizations l10n) labelBuilder;
}

const appTabSpecs = <AppTabSpec>[
  AppTabSpec(
    route: AppRoutes.home,
    icon: CupertinoIcons.home,
    labelBuilder: _homeLabel,
  ),
  AppTabSpec(
    route: AppRoutes.profile,
    icon: CupertinoIcons.person,
    labelBuilder: _profileLabel,
  ),
  AppTabSpec(
    route: AppRoutes.settings,
    icon: CupertinoIcons.settings,
    labelBuilder: _settingsLabel,
  ),
];

const _homeLabel = _Label.home;
const _profileLabel = _Label.profile;
const _settingsLabel = _Label.settings;

class _Label {
  const _Label._();

  static String home(AppLocalizations l10n) => l10n.home;
  static String profile(AppLocalizations l10n) => l10n.profile;
  static String settings(AppLocalizations l10n) => l10n.settings;
}
