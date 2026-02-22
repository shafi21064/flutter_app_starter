// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_error_view.dart
// PURPOSE : Reusable error display with an optional retry button.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import '../utils/app_sizes.dart';

/// Displays an error message centred on screen.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

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
              Icons.error_outline,
              size: AppSizes.iconLg,
              color: theme.colorScheme.error,
            ),
            Gap(AppSizes.spacingMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              Gap(AppSizes.spacingLg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
