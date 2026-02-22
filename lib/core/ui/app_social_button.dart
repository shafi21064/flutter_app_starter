// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_social_button.dart
// PURPOSE : Reusable social login button with unified Cupertino styling.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import '../utils/app_sizes.dart';

class AppSocialButton extends StatelessWidget {
  const AppSocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    
    return CupertinoButton(
      padding: EdgeInsets.all(AppSizes.spacingMd),
      color: color ?? CupertinoColors.systemFill,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      onPressed: onPressed,
      child: Icon(
        icon,
        size: AppSizes.iconMd,
        color: theme.primaryColor,
      ),
    );
  }
}
