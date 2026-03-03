import 'package:enyx_starter/core/config/env_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvValidation', () {
    test('collectIssues returns deterministic shape', () {
      final issues = EnvValidation.collectIssues();
      for (final issue in issues) {
        expect(issue.code, isNotEmpty);
        expect(issue.message, isNotEmpty);
      }
    });
  });
}
