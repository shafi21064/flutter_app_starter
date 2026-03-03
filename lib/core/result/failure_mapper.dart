import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'result.dart';

class FailureMapper {
  const FailureMapper._();

  static Failure<T> fromException<T>(Object error) {
    if (error is Failure<T>) return error;

    if (error is AuthException) {
      return Failure<T>(
        error.message,
        kind: FailureKind.auth,
        exception: error,
      );
    }

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return Failure<T>(
          'No internet connection. Please try again.',
          kind: FailureKind.offline,
          exception: error,
        );
      }
      return Failure<T>(
        error.message ?? 'Network request failed',
        kind: FailureKind.server,
        exception: error,
      );
    }

    return Failure<T>(
      'An unexpected error occurred',
      kind: FailureKind.unknown,
      exception: error,
    );
  }
}
