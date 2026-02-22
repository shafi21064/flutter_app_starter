// ──────────────────────────────────────────────────────────────
// lib/core/result/result.dart
// PURPOSE : Strongly-typed Result monad so we NEVER return null
//           on error. Every fallible operation returns
//           Result<T> = Success<T> | Failure.
//
// HOW TO EXTEND:
//   - Add new FailureKind variants as your app grows.
//   - Use the `.when()` / `.map()` helpers for exhaustive handling.
// ──────────────────────────────────────────────────────────────

/// A discriminated union representing either a [Success] value or a [Failure].
///
/// ```dart
/// final result = await authService.signIn(email, password);
/// result.when(
///   success: (user) => print(user),
///   failure: (f)    => showError(f.message),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Pattern-match on success / failure.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Failure<T>() => failure(this as Failure<T>),
    };
  }

  /// Map the success value, pass through failure.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Success(transform(data)),
      Failure<T>() => Failure<R>(
          (this as Failure<T>).message,
          kind: (this as Failure<T>).kind,
          exception: (this as Failure<T>).exception,
        ),
    };
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  /// Unwrap with a fallback if failure.
  T getOrElse(T Function() fallback) {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>() => fallback(),
    };
  }
}

/// Represents a successful result carrying [data].
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Represents a failure with a human-readable [message],
/// an optional [kind] for programmatic handling, and the
/// original [exception] for logging.
final class Failure<T> extends Result<T> {
  const Failure(
    this.message, {
    this.kind = FailureKind.unknown,
    this.exception,
  });

  final String message;
  final FailureKind kind;
  final Object? exception;

  @override
  String toString() => 'Failure($kind): $message';
}

/// Categorise failures for programmatic branching.
enum FailureKind {
  /// Network unreachable.
  offline,

  /// HTTP / Supabase returned an error status.
  server,

  /// Credential / session issues.
  auth,

  /// Input validation failed.
  validation,

  /// Feature disabled via feature flags.
  featureDisabled,

  /// Catch-all.
  unknown,
}
