// ──────────────────────────────────────────────────────────────
// lib/features/auth/presentation/controller/auth_controller.dart
// PURPOSE : Controller for auth operations.
//           Exposes methods to UI and delegates to AuthService.
// ──────────────────────────────────────────────────────────────
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../backend/auth_service.dart';
import '../../../../core/result/result.dart';

/// Loading / idle state for auth actions.
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// Convenience methods the UI calls for auth interactions.
class AuthController {
  AuthController(this._ref);
  final Ref _ref;

  AuthService get _auth => _ref.read(authServiceProvider);

  Future<Result<void>> signIn(String email, String password) async {
    _ref.read(authLoadingProvider.notifier).state = true;
    final result = await _auth.signIn(email: email, password: password);
    _ref.read(authLoadingProvider.notifier).state = false;
    return result.map((_) {});
  }

  Future<Result<void>> signUp(String email, String password) async {
    _ref.read(authLoadingProvider.notifier).state = true;
    final result = await _auth.signUp(email: email, password: password);
    _ref.read(authLoadingProvider.notifier).state = false;
    return result.map((_) {});
  }

  Future<Result<void>> resetPassword(String email) async {
    _ref.read(authLoadingProvider.notifier).state = true;
    final result = await _auth.resetPassword(email);
    _ref.read(authLoadingProvider.notifier).state = false;
    return result;
  }

  Future<Result<void>> signInWithGoogle() async {
    _ref.read(authLoadingProvider.notifier).state = true;
    final result = await _auth.signInWithGoogle();
    _ref.read(authLoadingProvider.notifier).state = false;
    return result;
  }

  Future<Result<void>> signInWithApple() async {
    _ref.read(authLoadingProvider.notifier).state = true;
    final result = await _auth.signInWithApple();
    _ref.read(authLoadingProvider.notifier).state = false;
    return result;
  }

  Future<Result<void>> signOut() async {
    return _auth.signOut();
  }
}

/// Provider for the auth controller.
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});
