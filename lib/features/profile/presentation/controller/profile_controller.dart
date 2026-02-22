// ──────────────────────────────────────────────────────────────
// lib/features/profile/presentation/controller/profile_controller.dart
// PURPOSE : UI State management for the profile feature.
//           Interacts with the Domain layer using Entities.
// ──────────────────────────────────────────────────────────────
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/profile_entity.dart';
import '../../data/repositories/profile_repository_impl.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<ProfileEntity>>((ref) {
      return ProfileController(ref);
    });

class ProfileController extends StateNotifier<AsyncValue<ProfileEntity>> {
  ProfileController(this._ref) : super(const AsyncLoading());

  final Ref _ref;

  Future<void> loadProfile(String userId) async {
    state = const AsyncLoading();
    final repo = _ref.read(profileRepositoryProvider);
    final result = await repo.getProfile(userId);

    result.when(
      success: (data) => state = AsyncData(data),
      failure: (f) => state = AsyncError(f.message, StackTrace.current),
    );
  }

  Future<void> updateBio(String bio) async {
    final currentData = state.value;
    if (currentData == null) return;

    final updated = currentData.copyWith(bio: bio);
    final repo = _ref.read(profileRepositoryProvider);

    // Optimistic update
    state = AsyncData(updated);

    final result = await repo.updateProfile(updated);
    result.when(
      success: (_) {},
      failure: (f) {
        // Rollback on failure
        state = AsyncData(currentData);
      },
    );
  }
}
