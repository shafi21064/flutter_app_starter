// ──────────────────────────────────────────────────────────────
// lib/features/profile/presentation/view/profile_view.dart
// PURPOSE : Cupertino-styled profile screen.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/app_scaffold.dart';
import '../../../../core/utils/app_sizes.dart';
import '../controller/profile_controller.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.userId.isNotEmpty) {
        ref.read(profileControllerProvider.notifier).loadProfile(widget.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final proxfileState = ref.watch(profileControllerProvider);
    return AppScaffold(
      title: 'Profile',
      body: widget.userId.isEmpty
          ? const Center(child: Text('Missing user id'))
          : profileState.when(
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
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
                    _BioSection(bio: profile.bio ?? 'No bio yet'),
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
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: CupertinoColors.systemFill,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'BIO',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Gap(AppSizes.spacingXs),
          Text(bio),
        ],
      ),
    );
  }
}
