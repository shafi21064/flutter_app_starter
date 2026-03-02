// ──────────────────────────────────────────────────────────────
// lib/features/profile/presentation/view/profile_view.dart
// PURPOSE : Cupertino-styled profile screen.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/ui/app_scaffold.dart';
import '../../../../core/utils/app_sizes.dart';
import '../controller/profile_controller.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key, this.userId});
  final String? userId;

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late final String _resolvedUserId;

  @override
  void initState() {
    super.initState();
    _resolvedUserId =
        widget.userId ?? Supabase.instance.client.auth.currentUser?.id ?? '';

    Future.microtask(() {
      if (_resolvedUserId.isNotEmpty) {
        ref
            .read(profileControllerProvider.notifier)
            .loadProfile(_resolvedUserId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    return AppScaffold(
      title: l10n.profile,
      body: _resolvedUserId.isEmpty
          ? Center(child: Text(l10n.profileMissingUserId))
          : profileState.when(
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) =>
                  Center(child: Text(l10n.errorWithMessage(err.toString()))),
              data: (profile) => SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.person_crop_circle_fill, size: 80),
                    Gap(AppSizes.spacingLg),
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      profile.email,
                      style: const TextStyle(color: CupertinoColors.systemGrey),
                    ),
                    Gap(AppSizes.spacingXl),
                    _BioSection(bio: profile.bio ?? l10n.profileNoBio),
                  ],
                ),
              ),
            ),
    );
  }
}

class _BioSection extends ConsumerWidget {
  const _BioSection({required this.bio});
  final String bio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: CupertinoColors.systemFill,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.profileBioHeader,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Gap(AppSizes.spacingXs),
          Text(bio),
        ],
      ),
    );
  }
}
