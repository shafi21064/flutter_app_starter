// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => _ProfileDto(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  bio: json['bio'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$ProfileDtoToJson(_ProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'bio': instance.bio,
      'avatar_url': instance.avatarUrl,
    };
