// ──────────────────────────────────────────────────────────────
// lib/features/auth/domain/app_user.dart
// PURPOSE : Lightweight domain model for the authenticated user.
//           Decouples feature code from the Supabase User class.
//
// HOW TO EXTEND:
//   Add profile fields (avatar, display name) and map them from
//   Supabase user_metadata.
// ──────────────────────────────────────────────────────────────

/// A simple domain model representing the authenticated user.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;

  /// Factory from Supabase user_metadata.
  factory AppUser.fromSupabase(Map<String, dynamic> json, String id) {
    return AppUser(
      id: id,
      email: json['email'] as String? ?? '',
      displayName: json['full_name'] as String? ??
          json['name'] as String?,
    );
  }
}
