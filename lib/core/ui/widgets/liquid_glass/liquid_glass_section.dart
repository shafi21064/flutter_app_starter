import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'liquid_glass_card.dart';

class LiquidGlassSection extends StatelessWidget {
  const LiquidGlassSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.padding = const EdgeInsets.all(14),
    this.gap = 10,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      borderRadius: 22,
      blur: 16,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(color: Colors.white.withAlpha(165), fontSize: 13),
            ),
          ],
          SizedBox(height: gap),
          ..._withGap(children, gap),
        ],
      ),
    );
  }

  List<Widget> _withGap(List<Widget> items, double spacing) {
    if (items.isEmpty) return const [];
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) out.add(SizedBox(height: spacing));
    }
    return out;
  }
}
