import 'env.dart';

enum EnvIssueSeverity { error, warning }

class EnvIssue {
  const EnvIssue({
    required this.code,
    required this.message,
    required this.severity,
  });

  final String code;
  final String message;
  final EnvIssueSeverity severity;
}

class EnvValidation {
  const EnvValidation._();

  static List<EnvIssue> collectIssues() {
    final issues = <EnvIssue>[];

    if (Env.supabaseUrl.isEmpty) {
      issues.add(
        const EnvIssue(
          code: 'SUPABASE_URL_MISSING',
          message: 'SUPABASE_URL is missing in .env',
          severity: EnvIssueSeverity.error,
        ),
      );
    }
    if (Env.supabaseAnonKey.isEmpty) {
      issues.add(
        const EnvIssue(
          code: 'SUPABASE_ANON_KEY_MISSING',
          message: 'SUPABASE_ANON_KEY is missing in .env',
          severity: EnvIssueSeverity.error,
        ),
      );
    }
    if (Env.hasSupabaseKeys && !Env.supabaseUrl.startsWith('https://')) {
      issues.add(
        const EnvIssue(
          code: 'SUPABASE_URL_INVALID',
          message: 'SUPABASE_URL should start with https://',
          severity: EnvIssueSeverity.error,
        ),
      );
    }
    if (Env.apiBaseUrl.isEmpty || Env.apiBaseUrl.contains('api.example.com')) {
      issues.add(
        const EnvIssue(
          code: 'API_BASE_URL_PLACEHOLDER',
          message:
              'API_BASE_URL is placeholder/empty. External API calls will fail.',
          severity: EnvIssueSeverity.warning,
        ),
      );
    }
    if (!Env.oauthRedirectUrl.contains('://')) {
      issues.add(
        const EnvIssue(
          code: 'OAUTH_REDIRECT_URL_INVALID',
          message: 'OAUTH_REDIRECT_URL should be a valid URI scheme.',
          severity: EnvIssueSeverity.error,
        ),
      );
    }

    return issues;
  }

  static bool get hasBlockingIssue =>
      collectIssues().any((issue) => issue.severity == EnvIssueSeverity.error);
}
