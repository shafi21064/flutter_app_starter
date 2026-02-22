// ──────────────────────────────────────────────────────────────
// lib/features/profile/data/repositories/profile_repository_impl.dart
// PURPOSE : Implementation of ProfileRepository.
//           Orchestrates data sources and maps DTOs to Entities.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../backend/rest_api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_dto.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.read(restApiClientProvider));
});

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._client);
  final RestApiClient _client;

  @override
  Future<Result<ProfileEntity>> getProfile(String userId) async {
    final result = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.userDetails(userId),
    );

    return result.when(
      success: (data) => Success(ProfileDto.fromJson(data).toEntity()),
      failure: (f) => Failure(f.message, kind: f.kind, exception: f.exception),
    );
  }

  @override
  Future<Result<void>> updateProfile(ProfileEntity profile) async {
    final dto = ProfileDto.fromEntity(profile);
    return await _client.post<void>(ApiEndpoints.profile, data: dto.toJson());
  }
}
