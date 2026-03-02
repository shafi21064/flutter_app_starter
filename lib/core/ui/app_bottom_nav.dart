import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../localization/l10n/app_localizations.dart';
import '../routing/app_router.dart';

enum AppBottomNavTab { home, profile, settings }

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentTab});

  final AppBottomNavTab currentTab;

  int get _currentIndex => switch (currentTab) {
        AppBottomNavTab.home => 0,
        AppBottomNavTab.profile => 1,
        AppBottomNavTab.settings => 2,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = Supabase.instance.client.auth.currentUser;

    return CupertinoTabBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(AppRoutes.home);
            break;
          case 1:
            if (user != null) {
              context.go(AppRoutes.profilePath(user.id));
            }
            break;
          case 2:
            context.go(AppRoutes.settings);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.home),
          label: l10n.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.person),
          label: l10n.profile,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.settings),
          label: l10n.settings,
        ),
      ],
    );
  }
}
