// ──────────────────────────────────────────────────────────────
// lib/core/connectivity/offline_banner.dart
// PURPOSE : A dismissible banner displayed at the top of the
//           widget tree when the device goes offline.
//
// HOW TO USE:
//   Wrap your Scaffold body or place inside a Column at the top.
//   The widget auto-shows/hides based on connectivityProvider.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';

import '../utils/app_colors.dart';
import 'connectivity_controller.dart';

/// Shows a coloured banner when the device is offline.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);
    if (isOnline) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    return MaterialBanner(
      content: Text(
        l10n.offlineBanner,
        style: const TextStyle(color: AppColors.white),
      ),
      backgroundColor: AppColors.error,
      leading: const Icon(Icons.wifi_off, color: AppColors.white),
      actions: const [SizedBox.shrink()], // required by MaterialBanner
    );
  }
}
