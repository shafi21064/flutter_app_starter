import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'liquid_glass_card.dart';

enum LiquidGlassButtonVariant { primary, ghost }

class LiquidGlassButton extends StatelessWidget {
  const LiquidGlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.variant = LiquidGlassButtonVariant.primary,
    this.fullWidth = true,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final LiquidGlassButtonVariant variant;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final isPrimary = variant == LiquidGlassButtonVariant.primary;

    final fg = enabled
        ? (isPrimary ? Colors.white : Colors.white.withAlpha(230))
        : Colors.white.withAlpha(120);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme(data: IconThemeData(color: fg, size: 18), child: leading!),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    content = LiquidGlassCard(
      borderRadius: 18,
      blur: isPrimary ? 18 : 14,
      padding: padding,
      child: fullWidth
          ? Center(child: content)
          : content,
    );

    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
