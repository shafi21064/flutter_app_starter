// ──────────────────────────────────────────────────────────────
// lib/features/auth/presentation/view/forgot_password_view.dart
// PURPOSE : Simple form to send a password-reset email.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:enyx_starter/core/ui/app_scaffold.dart';
import 'package:enyx_starter/core/ui/app_toast.dart';
import 'package:enyx_starter/core/utils/app_sizes.dart';
import 'package:enyx_starter/core/utils/app_colors.dart';
import 'package:enyx_starter/core/utils/haptic_service.dart';
import 'package:enyx_starter/core/config/feature_flags.dart';
import '../controller/auth_controller.dart';

class ForgotPasswordView extends HookConsumerWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final isLoading = useState(false);

    final l10n = AppLocalizations.of(context)!;
    final theme = CupertinoTheme.of(context);
    final flags = ref.watch(featureFlagsProvider);

    Future<void> reset() async {
      isLoading.value = true;
      final result = await ref
          .read(authControllerProvider)
          .resetPassword(emailController.text.trim());
      isLoading.value = false;

      if (!context.mounted) return;
      result.when(
        success: (_) {
          AppToast.success(context, l10n.resetLinkSent);
        },
        failure: (f) => AppToast.error(context, f.message),
      );
    }

    return AppScaffold(
      title: l10n.forgotPassword,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.pagePadding),
          child: Container(
            constraints: BoxConstraints(maxWidth: AppSizes.formMaxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (flags.enableEmailPasswordLogin) ...[
                  Text(
                    l10n.resetPassword,
                    style: theme.textTheme.textStyle,
                    textAlign: TextAlign.center,
                  ),
                  Gap(AppSizes.spacingXl),
                  LiquidGlassInput(
                    controller: emailController,
                    placeholder: l10n.email,
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Icon(
                      CupertinoIcons.mail,
                      color: AppColors.grey,
                    ),
                  ),
                  Gap(AppSizes.spacingLg),
                  isLoading.value
                      ? const Center(child: CupertinoActivityIndicator())
                      : LiquidGlassButton(
                          onPressed: reset,
                          label: l10n.sendResetLink,
                        ),
                  Gap(AppSizes.spacingMd),
                ],
                CupertinoButton(
                  onPressed: () {
                    HapticService.selectionClick();
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.alreadyHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
