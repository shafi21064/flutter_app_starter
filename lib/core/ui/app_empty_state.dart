// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_empty_state.dart
// PURPOSE : Placeholder shown when a list or view has no data.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import '../utils/app_sizes.dart';

/// Centred empty-state illustration + message.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({super.key, this.message, this.icon});

  final String? message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: AppSizes.iconXl,
              color: theme.disabledColor,
            ),
            Gap(AppSizes.spacingMd),
            Text(
              message ?? l10n.noData,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
