// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_loading_overlay.dart
// PURPOSE : Full-screen blocking loading indicator.
//           Drop on top of a Stack or use with showDialog.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:enyx_starter/core/utils/gap.dart';
import '../utils/app_colors.dart';
import '../utils/app_sizes.dart';

/// Displays a translucent overlay with a centered spinner.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, this.message});

  final String? message;

  /// Show the overlay as a barrier dialog (blocks interaction).
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppLoadingOverlay(message: message),
    );
  }

  /// Dismiss the overlay.
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: AppColors.loadingBarrier,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.pagePadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    Gap.h16,
                    Text(message!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
