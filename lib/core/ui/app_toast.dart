// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_toast.dart
// PURPOSE : Convenience helper to show Cupertino-style alerts.
//           Replacing Material Snackbars with CupertinoAlertDialog
//           for a pure iOS vibe.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

/// Show adaptive Cupertino alerts.
class AppToast {
  AppToast._();

  static Future<void> show(
    BuildContext context,
    String message, {
    String? title,
  }) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shortcut for error-styled alerts.
  static Future<void> error(BuildContext context, String message) {
    return show(context, message, title: 'Error');
  }

  /// Shortcut for success-styled alerts.
  static Future<void> success(BuildContext context, String message) {
    return show(context, message, title: 'Success');
  }
}
