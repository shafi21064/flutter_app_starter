// ──────────────────────────────────────────────────────────────
// lib/core/networking/api_endpoints.dart
// PURPOSE : Centralized storage for API endpoints.
// ──────────────────────────────────────────────────────────────

import '../config/env.dart';

class ApiEndpoints {
  const ApiEndpoints._();

  static String get baseUrl => Env.apiBaseUrl;

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';

  // Example functionality
  static String userDetails(String userId) => '/users/$userId';
  static const String posts = '/posts';
}
