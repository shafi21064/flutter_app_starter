import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'liquid_glass_card.dart';

class LiquidGlassListTile extends StatelessWidget {
  const LiquidGlassListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tile = LiquidGlassCard(
      borderRadius: 16,
      blur: 14,
      padding: padding,
      child: Row(
        children: [
          if (leading != null) ...[
            IconTheme(
              data: IconThemeData(color: Colors.white.withAlpha(230), size: 20),
              child: leading!,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: Colors.white.withAlpha(170),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing ??
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: Colors.white.withAlpha(180),
              ),
        ],
      ),
    );

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: tile,
    );
  }
}
