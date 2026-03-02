import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'liquid_glass_card.dart';

class LiquidGlassInput extends StatelessWidget {
  const LiquidGlassInput({
    super.key,
    required this.controller,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? placeholder;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      borderRadius: 16,
      blur: 14,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          if (prefix != null) ...[
            DefaultTextStyle(
              style: TextStyle(color: Colors.white.withAlpha(220)),
              child: IconTheme(
                data: IconThemeData(color: Colors.white.withAlpha(220), size: 18),
                child: prefix!,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              placeholder: placeholder,
              placeholderStyle: TextStyle(color: Colors.white.withAlpha(120)),
              style: const TextStyle(color: Colors.white),
              decoration: null,
              cursorColor: Colors.white,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 8),
            DefaultTextStyle(
              style: TextStyle(color: Colors.white.withAlpha(220)),
              child: IconTheme(
                data: IconThemeData(color: Colors.white.withAlpha(220), size: 18),
                child: suffix!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
