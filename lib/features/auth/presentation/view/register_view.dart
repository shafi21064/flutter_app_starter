// ──────────────────────────────────────────────────────────────
// lib/features/auth/presentation/view/register_view.dart
// PURPOSE : Registration screen with email + password + confirm.
// ──────────────────────────────────────────────────────────────

import 'package:enyx_starter/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:enyx_starter/core/config/feature_flags.dart';
import 'package:enyx_starter/core/routing/app_router.dart';
import 'package:enyx_starter/core/ui/app_divider.dart';
import 'package:enyx_starter/core/ui/app_scaffold.dart';
import 'package:enyx_starter/core/ui/app_social_button.dart';
import 'package:enyx_starter/core/ui/app_toast.dart';
import 'package:enyx_starter/core/ui/widgets/enyx_text_field.dart';
import 'package:enyx_starter/core/utils/app_sizes.dart';
import 'package:enyx_starter/core/utils/app_colors.dart';
import 'package:enyx_starter/core/utils/haptic_service.dart';

class RegisterView extends HookConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameController = useTextEditingController();
    final isLoading = useState(false);

    final l10n = AppLocalizations.of(context)!;
    final theme = CupertinoTheme.of(context);
    final flags = ref.watch(featureFlagsProvider);

    Future<void> register() async {
      isLoading.value = true;
      final result = await ref
          .read(authControllerProvider)
          .signUp(emailController.text.trim(), passwordController.text.trim());
      isLoading.value = false;

      if (!context.mounted) return;
      result.when(
        success: (_) async {
          await AppToast.success(context, l10n.verifyEmailAfterRegister);
          if (!context.mounted) return;
          context.go(AppRoutes.login);
        },
        failure: (f) async => AppToast.error(context, f.message),
      );
    }

    return AppScaffold(
      title: l10n.register,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.pagePadding),
          child: Container(
            constraints: BoxConstraints(maxWidth: AppSizes.formMaxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.register,
                  style: theme.textTheme.textStyle,
                  textAlign: TextAlign.center,
                ),
                Gap(AppSizes.spacingXl),
                if (flags.enableEmailPasswordLogin) ...[
                  EnyxTextField(
                    controller: nameController,
                    placeholder: l10n.fullName,
                    prefix: const Icon(
                      CupertinoIcons.person,
                      color: AppColors.grey,
                    ),
                  ),
                  Gap(AppSizes.spacingMd),
                  EnyxTextField(
                    controller: emailController,
                    placeholder: l10n.email,
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Icon(
                      CupertinoIcons.mail,
                      color: AppColors.grey,
                    ),
                  ),
                  Gap(AppSizes.spacingMd),
                  EnyxTextField(
                    controller: passwordController,
                    placeholder: l10n.password,
                    obscureText: true,
                    showPasswordToggle: true,
                    prefix: const Icon(
                      CupertinoIcons.padlock,
                      color: AppColors.grey,
                    ),
                  ),
                  Gap(AppSizes.spacingLg),
                  isLoading.value
                      ? const Center(child: CupertinoActivityIndicator())
                      : CupertinoButton.filled(
                          onPressed: register,
                          child: Text(l10n.register),
                        ),
                  Gap(AppSizes.spacingMd),
                ],
                if (flags.isGoogleLoginVisible ||
                    flags.isAppleLoginVisible) ...[
                  if (flags.enableEmailPasswordLogin) ...[
                    const AppDividerWithText(text: 'OR'),
                    Gap(AppSizes.spacingLg),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (flags.isGoogleLoginVisible)
                        AppSocialButton(
                          icon: Icons.g_mobiledata,
                          onPressed: () async {
                            HapticService.mediumImpact();
                            final res = await ref
                                .read(authControllerProvider)
                                .signInWithGoogle();
                            if (!context.mounted) return;
                            res.when(
                              success: (_) => context.go(AppRoutes.home),
                              failure: (f) =>
                                  AppToast.error(context, f.message),
                            );
                          },
                        ),
                      if (flags.isAppleLoginVisible)
                        AppSocialButton(
                          icon: CupertinoIcons.ant_fill,
                          onPressed: () async {
                            HapticService.mediumImpact();
                            final res = await ref
                                .read(authControllerProvider)
                                .signInWithApple();
                            if (!context.mounted) return;
                            res.when(
                              success: (_) => context.go(AppRoutes.home),
                              failure: (f) =>
                                  AppToast.error(context, f.message),
                            );
                          },
                        ),
                    ],
                  ),
                  Gap(AppSizes.spacingLg),
                ],
                CupertinoButton(
                  onPressed: () {
                    HapticService.selectionClick();
                    context.pop();
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
