// ──────────────────────────────────────────────────────────────
// lib/core/utils/validators.dart
// PURPOSE : Reusable form-field validators for email, password,
//           and other common fields.
//
// HOW TO EXTEND:
//   Add new static methods following the same pattern.
// ──────────────────────────────────────────────────────────────

/// Collection of common form validators.
class Validators {
  Validators._();

  /// Basic email format check.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.\w{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Password must be at least 8 characters.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  /// Checks that [value] matches [password].
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value != password) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  /// Generic required-field check.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
