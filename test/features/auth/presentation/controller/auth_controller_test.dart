import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enyx_starter/backend/auth_service.dart';
import 'package:enyx_starter/core/result/result.dart';
import 'package:enyx_starter/features/auth/presentation/controller/auth_controller.dart';

class _FakeAuthService extends AuthService {
  _FakeAuthService(super.ref, {required this.onSignInWithGoogle});

  final Future<Result<void>> Function() onSignInWithGoogle;

  @override
  Future<Result<void>> signInWithGoogle() => onSignInWithGoogle();
}

void main() {
  group('AuthController loading state', () {
    test('resets loading after normal completion', () async {
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWith(
            (ref) => _FakeAuthService(
              ref,
              onSignInWithGoogle: () async => const Failure<void>('failed'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);

      final future = controller.signInWithGoogle();
      expect(container.read(authLoadingProvider), isTrue);

      final result = await future;
      expect(result.isFailure, isTrue);
      expect(container.read(authLoadingProvider), isFalse);
    });

    test('maps throw to Failure and resets loading', () async {
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWith(
            (ref) => _FakeAuthService(
              ref,
              onSignInWithGoogle: () async {
                throw Exception('boom');
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);

      final future = controller.signInWithGoogle();
      expect(container.read(authLoadingProvider), isTrue);

      final result = await future;
      expect(result.isFailure, isTrue);
      expect(container.read(authLoadingProvider), isFalse);
    });
  });
}
