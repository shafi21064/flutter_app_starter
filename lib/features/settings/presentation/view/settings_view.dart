// ──────────────────────────────────────────────────────────────
// lib/features/settings/presentation/view/settings_view.dart
// PURPOSE : Settings screen with theme selector, typography
//           selector, language selector, and read-only flags.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';

import '../../../../core/config/feature_flags.dart';
import '../../../../core/config/env.dart';
import '../../../../core/connectivity/connectivity_controller.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/theme/theme_packs.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/ui/app_scaffold.dart';
import '../../../../core/utils/app_sizes.dart';
import '../controller/settings_controller.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final flags = ref.watch(featureFlagsProvider);
    final currentThemeKey = ref.watch(themeKeyProvider);
    final currentFontKey = ref.watch(fontFamilyProvider);
    final currentLocale = ref.watch(localeProvider);
    final ctrl = ref.read(settingsControllerProvider);
    final isOnline = ref.watch(connectivityProvider);

    String flagLabel(bool value) => value ? l10n.enabled : l10n.disabled;

    return AppScaffold(
      title: l10n.settings,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spacingSm),
        children: [
          // ── Theme selector ──────────────────────────────────
          _SectionHeader(l10n.theme),
          ...themePacks.entries.map((entry) {
            final isSelected = entry.key == currentThemeKey;
            return ListTile(
              title: Text(entry.value.label),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              onTap: () => ctrl.setTheme(entry.key),
            );
          }),

          const Divider(),

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

          const Divider(),

          // ── Language selector ───────────────────────────────
          _SectionHeader(l10n.language),
          ...supportedLocales.map((loc) {
            final isSelected = loc == currentLocale;
            return ListTile(
              title: Text(_localeLabel(loc)),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              onTap: () => ctrl.setLocale(loc),
            );
          }),

          const Divider(),

          // ── Auth options (read-only) ────────────────────────
          _SectionHeader(l10n.authOptions),
          _FlagTile(
            l10n.emailPasswordEnabled,
            flagLabel(flags.enableEmailPasswordLogin),
          ),
          _FlagTile(
            l10n.socialLoginEnabled,
            flagLabel(flags.enableSocialLogin),
          ),
          _FlagTile(
            l10n.googleLoginEnabled,
            flagLabel(flags.isGoogleLoginVisible),
          ),
          _FlagTile(
            l10n.appleLoginEnabled,
            flagLabel(flags.isAppleLoginVisible),
          ),

          const Divider(),

          // ── IAP ─────────────────────────────────────────────
          _FlagTile(l10n.iapEnabled, flagLabel(flags.enableIap)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMd,
              vertical: AppSizes.spacingXs,
            ),
            child: Text(
              'Configure enableIap via feature_flags.dart or remote config.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ),

          const Divider(),

          // ── Flavor ──────────────────────────────────────────
          _FlagTile(l10n.appFlavor, Env.flavor.toUpperCase()),

          // ── Dev-only: test offline banner ───────────────────
          if (Env.isDev) ...[
            const Divider(),
            _SectionHeader('Dev Tools'),
            SwitchListTile(
              title: const Text('Simulate Offline'),
              subtitle: Text(
                isOnline ? 'Currently online' : 'Currently offline',
              ),
              value: !isOnline,
              onChanged: (_) {
                // demonstrative only
              },
            ),
          ],
        ],
      ),
    );
  }

  String _localeLabel(Locale loc) {
    switch (loc.languageCode) {
      case 'bn':
        return 'বাংলা';
      case 'en':
      default:
        return 'English';
    }
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

class _FlagTile extends StatelessWidget {
  const _FlagTile(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(value, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
