// ──────────────────────────────────────────────────────────────
// lib/features/auth/presentation/controller/auth_controller.dart
// PURPOSE : Controller for auth operations.
//           Exposes methods to UI and delegates to AuthService.
// ──────────────────────────────────────────────────────────────
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../backend/auth_service.dart';
import '../../../../core/result/failure_mapper.dart';
import '../../../../core/result/result.dart';

/// Loading / idle state for auth actions.
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// Convenience methods the UI calls for auth interactions.
class AuthController {
  AuthController(this._ref);
  final Ref _ref;

  AuthService get _auth => _ref.read(authServiceProvider);

  Future<Result<void>> signIn(String email, String password) async {
    return _guard(() async {
      final result = await _auth.signIn(email: email, password: password);
      return result.map((_) {});
    });
  }

  Future<Result<void>> signUp(String email, String password) async {
    return _guard(() async {
      final result = await _auth.signUp(email: email, password: password);
      return result.map((_) {});
    });
  }

  Future<Result<void>> resetPassword(String email) async {
    return _guard(() => _auth.resetPassword(email));
  }

  Future<Result<void>> signInWithGoogle() async {
    return _guard(() => _auth.signInWithGoogle());
  }

  Future<Result<void>> signInWithApple() async {
    return _guard(() => _auth.signInWithApple());
  }

  Future<Result<void>> signOut() async {
    return _guard(() => _auth.signOut(), updateLoading: false);
  }

  Future<Result<void>> _guard(
    Future<Result<void>> Function() task, {
    bool updateLoading = true,
  }) async {
    if (updateLoading) {
      _ref.read(authLoadingProvider.notifier).state = true;
    }
    try {
      return await task();
    } catch (error) {
      return FailureMapper.fromException<void>(error);
    } finally {
      if (updateLoading) {
        _ref.read(authLoadingProvider.notifier).state = false;
      }
    }
  }
}

/// Provider for the auth controller.
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});
