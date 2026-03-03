// ──────────────────────────────────────────────────────────────
// lib/features/boot/presentation/view/missing_keys_view.dart
// PURPOSE : Shown when SUPABASE_URL or SUPABASE_ANON_KEY are
//           not set in .env.
//           Prevents any Supabase calls and explains what to do.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:enyx_starter/core/utils/gap.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';

import 'package:enyx_starter/core/config/env_validation.dart';
import 'package:enyx_starter/core/ui/app_scaffold.dart';
import 'package:enyx_starter/core/utils/app_sizes.dart';

class MissingKeysView extends StatelessWidget {
  const MissingKeysView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final issues = EnvValidation.collectIssues();

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
              Gap.h24,
              Text(
                l10n.missingKeysTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Gap.h16,
              Text(
                l10n.missingKeysBody,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (issues.isNotEmpty) ...[
                Gap.h24,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Configuration checks',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Gap.h12,
                ...issues.map(
                  (issue) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          issue.severity == EnvIssueSeverity.error
                              ? Icons.error_outline
                              : Icons.warning_amber_outlined,
                          size: AppSizes.subheadingSize,
                          color: issue.severity == EnvIssueSeverity.error
                              ? theme.colorScheme.error
                              : theme.colorScheme.secondary,
                        ),
                        Gap.w8,
                        Expanded(
                          child: Text(
                            issue.message,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
