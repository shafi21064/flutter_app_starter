// ──────────────────────────────────────────────────────────────
// lib/features/boot/presentation/view/missing_keys_view.dart
// PURPOSE : Shown when SUPABASE_URL or SUPABASE_ANON_KEY are
//           not provided via --dart-define.
//           Prevents any Supabase calls and explains what to do.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';

import 'package:enyx_starter/core/ui/app_scaffold.dart';
import 'package:enyx_starter/core/utils/app_sizes.dart';

class MissingKeysView extends StatelessWidget {
  const MissingKeysView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppScaffold(
      title: l10n.missingKeysTitle,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.vpn_key_off,
                size: AppSizes.iconXl,
                color: theme.colorScheme.error,
              ),
              Gap(AppSizes.spacingLg),
              Text(
                l10n.missingKeysTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Gap(AppSizes.spacingMd),
              Text(
                l10n.missingKeysBody,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
