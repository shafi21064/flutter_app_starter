// ──────────────────────────────────────────────────────────────
// lib/features/profile/domain/entities/profile_entity.dart
// PURPOSE : The "clean" model used by the UI and business logic.
//           It has no knowledge of JSON or external APIs.
// ──────────────────────────────────────────────────────────────

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

@freezed
abstract class ProfileEntity with _$ProfileEntity {
  // ignore: unused_element
  const ProfileEntity._();
  const factory ProfileEntity({
    required String id,
    required String name,
    required String email,
    String? bio,
    String? avatarUrl,
  }) = _ProfileEntity;
}
