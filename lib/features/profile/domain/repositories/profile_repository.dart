// ──────────────────────────────────────────────────────────────
// lib/features/profile/domain/repositories/profile_repository.dart
// PURPOSE : Interface for profile data operations.
//           The domain layer defines what it needs, not how it's done.
// ──────────────────────────────────────────────────────────────

import '../../../../core/result/result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile(String userId);
  Future<Result<void>> updateProfile(ProfileEntity profile);
}
