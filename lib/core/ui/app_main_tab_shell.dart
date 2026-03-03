import 'package:flutter/cupertino.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';

import '../localization/l10n/app_localizations.dart';

class AppMainTabShell extends StatelessWidget {
  const AppMainTabShell({
    super.key,
    required this.currentIndex,
    required this.onTabTap,
    required this.child,
  });

  final int currentIndex;
  final ValueChanged<int> onTabTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LiquidBottomNavScaffold.router(
      currentIndex: currentIndex,
      onTap: onTabTap,
      routerChild: child,
      items: [
        LiquidGlassBottomNavItem(icon: CupertinoIcons.home, label: l10n.home),
        LiquidGlassBottomNavItem(
          icon: CupertinoIcons.person,
          label: l10n.profile,
        ),
        LiquidGlassBottomNavItem(
          icon: CupertinoIcons.settings,
          label: l10n.settings,
        ),
      ],
      background: Image.asset("assets/images/themes/bg.jpg", fit: BoxFit.cover),
    );
  }
}
