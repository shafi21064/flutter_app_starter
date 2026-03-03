// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_divider.dart
// PURPOSE : Reusable Cupertino-styled divider widgets.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import '../utils/app_sizes.dart';

/// A simple single-pixel horizontal line using Cupertino separator color.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: CupertinoColors.separator);
  }
}

/// A horizontal divider with centered text, useful for "OR" sections.
class AppDividerWithText extends StatelessWidget {
  const AppDividerWithText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: AppDivider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingSm),
          child: Text(
            text,
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: AppSizes.captionSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: AppDivider()),
      ],
    );
  }
}
