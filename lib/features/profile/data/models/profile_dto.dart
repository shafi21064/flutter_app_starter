// ──────────────────────────────────────────────────────────────
// lib/features/profile/data/models/profile_dto.dart
// PURPOSE : Data Transfer Object (DTO) for API communication.
//           This is where the @JsonKey and mapping logic live.
//           If the API field name changes, only THIS file changes.
// ──────────────────────────────────────────────────────────────

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
abstract class ProfileDto with _$ProfileDto {
  const ProfileDto._(); // Required for custom methods

  const factory ProfileDto({
    required String id,
    required String name,
    required String email,
    String? bio,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  // ── Mapping helpers ─────────────────────────────────────────────────

  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    name: name,
    email: email,
    bio: bio,
    avatarUrl: avatarUrl,
  );

  factory ProfileDto.fromEntity(ProfileEntity entity) => ProfileDto(
    id: entity.id,
    name: entity.name,
    email: entity.email,
    bio: entity.bio,
    avatarUrl: entity.avatarUrl,
  );
}
