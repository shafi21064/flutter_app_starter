// ──────────────────────────────────────────────────────────────
// lib/features/auth/presentation/view/login_view.dart
// PURPOSE : Login screen with email/password + social buttons
//           controlled by feature flags.
// ──────────────────────────────────────────────────────────────

import 'package:enyx_starter/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Icons; // Fallback for some Material icons if needed
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:enyx_starter/core/config/feature_flags.dart';
import 'package:enyx_starter/core/routing/app_router.dart';
import 'package:enyx_starter/core/ui/app_divider.dart';
import 'package:enyx_starter/core/ui/app_scaffold.dart';
import 'package:enyx_starter/core/ui/app_social_button.dart';
import 'package:enyx_starter/core/ui/app_toast.dart';
import 'package:enyx_starter/core/utils/app_sizes.dart';
import 'package:enyx_starter/core/utils/app_colors.dart';
import 'package:enyx_starter/core/utils/haptic_service.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    final l10n = AppLocalizations.of(context)!;
    final theme = CupertinoTheme.of(context);
    final flags = ref.watch(featureFlagsProvider);

    Future<void> login() async {
      isLoading.value = true;
      final result = await ref
          .read(authControllerProvider)
          .signIn(emailController.text.trim(), passwordController.text.trim());
      isLoading.value = false;

      if (!context.mounted) return;
      result.when(
        success: (_) => context.go(AppRoutes.home),
        failure: (f) => AppToast.error(context, f.message),
      );
    }

    return AppScaffold(
      title: l10n.login,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.pagePadding),
          child: Container(
            constraints: BoxConstraints(maxWidth: AppSizes.formMaxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  CupertinoIcons.lock_shield,
                  size: AppSizes.iconXl,
                  color: theme.primaryColor,
                ),
                Gap(AppSizes.spacingLg),
                Text(
                  l10n.login,
                  style: theme.textTheme.navLargeTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
                Gap(AppSizes.spacingXl),
                if (flags.enableEmailPasswordLogin) ...[
                  LiquidGlassInput(
                    controller: emailController,
                    placeholder: l10n.email,
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Icon(
                      CupertinoIcons.mail,
                      color: AppColors.grey,
                    ),
                  ),
                  Gap(AppSizes.spacingMd),
                  LiquidGlassInput(
                    controller: passwordController,
                    placeholder: l10n.password,
                    obscureText: true,
                    showPasswordToggle: true,
                    prefix: const Icon(
                      CupertinoIcons.padlock,
                      color: AppColors.grey,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        HapticService.selectionClick();
                        context.push(AppRoutes.forgotPassword);
                      },
                      child: Text(l10n.forgotPassword),
                    ),
                  ),
                  Gap(AppSizes.spacingMd),
                  isLoading.value
                      ? const Center(child: CupertinoActivityIndicator())
                      : LiquidGlassButton(
                          onPressed: login,
                          label: l10n.login,
                        ),
                  Gap(AppSizes.spacingMd),
                  CupertinoButton(
                    onPressed: () {
                      HapticService.selectionClick();
                      context.push(AppRoutes.register);
                    },
                    child: Text(l10n.dontHaveAccount),
                  ),
                  Gap(AppSizes.spacingLg),
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
                              success: (_) {},
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
                              success: (_) {},
                              failure: (f) =>
                                  AppToast.error(context, f.message),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
