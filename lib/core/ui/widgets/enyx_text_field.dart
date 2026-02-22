import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:enyx_starter/core/utils/app_sizes.dart';
import 'package:enyx_starter/core/utils/haptic_service.dart';

/// A beautiful, standardized Cupertino-style text field with hooks-riverpod support.
class EnyxTextField extends HookConsumerWidget {
  const EnyxTextField({
    super.key,
    required this.controller,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? placeholder;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool showPasswordToggle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks state for visibility toggle if enabled
    final isObscured = useState(obscureText);

    Widget? effectiveSuffix = suffix;

    if (showPasswordToggle) {
      effectiveSuffix = CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          HapticService.selectionClick();
          isObscured.value = !isObscured.value;
        },
        child: Icon(
          isObscured.value ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
          size: 20,
        ),
      );
    }

    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      prefix: prefix != null
          ? Padding(
              padding: EdgeInsets.only(left: AppSizes.spacingMd),
              child: prefix,
            )
          : null,
      suffix: effectiveSuffix,
      obscureText: isObscured.value,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      onChanged: (value) {
        onChanged?.call(value);
      },
      padding: EdgeInsets.all(AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: CupertinoColors.extraLightBackgroundGray.withAlpha(200),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      onTap: () => HapticService.selectionClick(),
    );
  }
}
