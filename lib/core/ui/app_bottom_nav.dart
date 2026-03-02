import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../localization/l10n/app_localizations.dart';
import '../routing/app_router.dart';
import 'widgets/liquid_glass/liquid_glass_widgets.dart';

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
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    const activeColor = Colors.white;
    final inactiveColor = isDark
        ? Colors.white.withAlpha(150)
        : Colors.black.withAlpha(140);

    void onTapIndex(int index) {
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
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: LiquidGlassCard(
        borderRadius: 26,
        blur: 24,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: CupertinoIcons.home,
                label: l10n.home,
                selected: _currentIndex == 0,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTapIndex(0),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: CupertinoIcons.person,
                label: l10n.profile,
                selected: _currentIndex == 1,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTapIndex(1),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: CupertinoIcons.settings,
                label: l10n.settings,
                selected: _currentIndex == 2,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTapIndex(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 6),
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 21, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
