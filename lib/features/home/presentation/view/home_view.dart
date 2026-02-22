// ──────────────────────────────────────────────────────────────
// lib/features/home/presentation/view/home_view.dart
// PURPOSE : Main landing page after authentication.
//           Shows current user info and sign-out button.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:enyx_starter/core/config/env.dart';
import 'package:enyx_starter/core/routing/app_router.dart';
import 'package:enyx_starter/core/ui/app_scaffold.dart';
import 'package:enyx_starter/core/ui/app_toast.dart';
import 'package:enyx_starter/core/utils/app_sizes.dart';

import '../../../auth/presentation/controller/auth_controller.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Safely read the current user.
    final User? user = Env.hasSupabaseKeys
        ? Supabase.instance.client.auth.currentUser
        : null;

    final displayName =
        user?.userMetadata?['full_name'] as String? ??
            user?.email ??
            'User';

    return AppScaffold(
      title: l10n.appTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: l10n.settings,
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40 * AppSizes.scale,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              Gap(AppSizes.spacingMd),
              Text(
                l10n.welcomeUser(displayName),
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (user?.email != null) ...[
                Gap(AppSizes.spacingXs),
                Text(
                  user!.email!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
              ],
              Gap(AppSizes.spacingXl),
              if (user != null) ...[
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.profilePath(user.id)),
                  icon: const Icon(Icons.person),
                  label: const Text('Profile'),
                ),
                Gap(AppSizes.spacingMd),
              ],
              ElevatedButton.icon(
                onPressed: () async {
                  final result =
                      await ref.read(authControllerProvider).signOut();
                  if (!context.mounted) return;
                  result.when(
                    success: (_) {},
                    failure: (f) => AppToast.error(context, f.message),
                  );
                },
                icon: const Icon(Icons.logout),
                label: Text(l10n.signOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
