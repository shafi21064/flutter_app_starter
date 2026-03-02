// ──────────────────────────────────────────────────────────────
// lib/features/settings/presentation/view/settings_view.dart
// PURPOSE : Settings screen with theme selector, typography
//           selector, language selector, and read-only flags.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';

import '../../../../core/theme/theme_controller.dart';
// import '../../../../core/theme/theme_packs.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/ui/app_bottom_nav.dart';
import '../../../../core/ui/app_scaffold.dart';
import '../../../../core/utils/app_sizes.dart';
import '../controller/settings_controller.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    // final currentThemeKey = ref.watch(themeKeyProvider);
    final currentFontKey = ref.watch(fontFamilyProvider);
    final ctrl = ref.read(settingsControllerProvider);

    return AppScaffold(
      title: l10n.settings,
      bottomNavigationBar:
          const AppBottomNav(currentTab: AppBottomNavTab.settings),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spacingSm),
        children: [
          // // ── Theme selector ──────────────────────────────────
          // _SectionHeader(l10n.theme),
          // ...themePacks.entries.map((entry) {
          //   final isSelected = entry.key == currentThemeKey;
          //   return ListTile(
          //     title: Text(entry.value.label),
          //     leading: Icon(
          //       isSelected
          //           ? Icons.radio_button_checked
          //           : Icons.radio_button_unchecked,
          //       color: isSelected ? theme.colorScheme.primary : null,
          //     ),
          //     onTap: () => ctrl.setTheme(entry.key),
          //   );
          // }),

          // const Divider(),

          // ── Typography selector ────────────────────────────
          _SectionHeader(l10n.typography),
          ...appFonts.entries.map((entry) {
            final isSelected = entry.key == currentFontKey;
            return ListTile(
              title: Text(
                entry.value,
                style: TextStyle(
                  fontFamily: AppTypography.getFontFamily(entry.key),
                ),
              ),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              onTap: () => ctrl.setFontFamily(entry.key),
            );
          }),
        ],
      ),
    );
  }
}

// ── Small helper widgets ───────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingMd,
        AppSizes.spacingMd,
        AppSizes.spacingMd,
        AppSizes.spacingXs,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
