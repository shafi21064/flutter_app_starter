// ──────────────────────────────────────────────────────────────
// lib/features/profile/data/repositories/profile_repository_impl.dart
// PURPOSE : Implementation of ProfileRepository.
//           Orchestrates data sources and maps DTOs to Entities.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl();

  GoTrueClient get _auth => Supabase.instance.client.auth;

  ProfileEntity _mapUserToProfile(User user) {
    final data = user.userMetadata ?? const <String, dynamic>{};
    return ProfileEntity(
      id: user.id,
      name: (data['full_name'] as String?) ??
          (data['name'] as String?) ??
          user.email ??
          'User',
      email: user.email ?? '',
      bio: data['bio'] as String?,
      avatarUrl: data['avatar_url'] as String?,
    );
  }

  @override
  Future<Result<ProfileEntity>> getProfile(String userId) async {
    final user = _auth.currentUser;
    if (user == null) {
      return const Failure('Not signed in', kind: FailureKind.auth);
    }
    if (user.id != userId) {
      return const Failure(
        'Cannot access another user profile',
        kind: FailureKind.auth,
      );
    }
    return Success(_mapUserToProfile(user));
  }

  @override
  Future<Result<void>> updateProfile(ProfileEntity profile) async {
    final user = _auth.currentUser;
    if (user == null) {
      return const Failure('Not signed in', kind: FailureKind.auth);
    }
    if (user.id != profile.id) {
      return const Failure(
        'Cannot update another user profile',
        kind: FailureKind.auth,
      );
    }

    try {
      await _auth.updateUser(
        UserAttributes(
          data: <String, dynamic>{
            'full_name': profile.name,
            'bio': profile.bio,
            'avatar_url': profile.avatarUrl,
          },
        ),
      );
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(e.message, kind: FailureKind.auth, exception: e);
    } catch (e) {
      return Failure(
        'Failed to update profile',
        kind: FailureKind.unknown,
        exception: e,
      );
    }
  }
}
