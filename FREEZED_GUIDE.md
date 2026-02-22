# Freezed & Code Generation Guide ❄️

We use `freezed` and `json_serializable` for type-safe, immutable models and seamless JSON mapping.

## Why Freezed?
1.  **Immutability**: Prevents side effects.
2.  **Union types**: Perfect for State management (Loading, Success, Error).
3.  **Deep copy**: `copyWith` for updating nested objects.
4.  **Serialization**: Automated `fromJson` and `toJson`.

---

## 🏗 The Standard Model Structure

Always separate your models into **Domain Entities** and **Data DTOs**.

### 1. Domain Entity (The "Clean" Model)
Used by the UI. No JSON logic.
```dart
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
  }) = _UserEntity;
}
```

### 2. Data DTO (The "API" Model)
Handled JSON mapping and field renames.
```dart
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    @JsonKey(name: 'user_id_from_api') required String id,
    @JsonKey(name: 'full_name') required String name,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  
  // Mapping logic
  UserEntity toEntity() => UserEntity(id: id, name: name);
}
```

---

## 🔄 Code Generation Workflow

Whenever you add or change a `@freezed` class, run:

```bash
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Continuous watch (recommended during development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## ⚠️ Pro Tips
*   Always add `part 'filename.freezed.dart';` and `part 'filename.g.dart';` (if using JSON).
*   If your DTO list is empty after codegen, check if you matched the property types correctly (e.g., `int` vs `String`).
*   Use `@Default(value)` for optional fields to avoid null checks in the UI.
