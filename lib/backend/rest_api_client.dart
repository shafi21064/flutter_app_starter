// ──────────────────────────────────────────────────────────────
// lib/backend/rest_api_client.dart
// PURPOSE : Dio-based REST client for external (non-Supabase)
//           APIs such as third-party services or your own
//           edge-case endpoints.
//
// FEATURES:
//   - Logging interceptor (disabled in prod)
//   - Typed error mapping to Failure
//   - Cancel-token support
//   - Does NOT force JSON content-type for multipart uploads
//
// HOW TO USE:
//   final client = ref.read(restApiClientProvider);
//   final result = await client.get<Map>('/users/1');
// ──────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/env.dart';
import '../core/logging/log.dart';
import '../core/result/result.dart';

/// Riverpod provider for the REST API client.
final restApiClientProvider = Provider<RestApiClient>((ref) {
  return RestApiClient();
});

class RestApiClient {
  RestApiClient() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      // Do NOT set a global content-type – let Dio infer it for
      // multipart/form-data uploads.
    ));

    if (Env.enableHttpLogs) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => Log.d(obj.toString()),
      ));
    }
  }

  late final Dio _dio;

  // ── Public API ─────────────────────────────────────────────

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    return _request(() => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        ));
  }

  Future<Result<T>> post<T>(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  }) async {
    return _request(() => _dio.post<T>(
          path,
          data: data,
          cancelToken: cancelToken,
        ));
  }

  Future<Result<T>> put<T>(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  }) async {
    return _request(() => _dio.put<T>(
          path,
          data: data,
          cancelToken: cancelToken,
        ));
  }

  Future<Result<T>> delete<T>(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  }) async {
    return _request(() => _dio.delete<T>(
          path,
          data: data,
          cancelToken: cancelToken,
        ));
  }

  // ── Helpers ────────────────────────────────────────────────

  Future<Result<T>> _request<T>(
      Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return Success(response.data as T);
    } on DioException catch (e) {
      return Failure(
        _mapDioError(e),
        kind: _mapKind(e),
        exception: e,
      );
    } catch (e, st) {
      Log.e('REST request failed', error: e, stack: st);
      return Failure('Unexpected network error',
          kind: FailureKind.unknown, exception: e);
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out';
      case DioExceptionType.connectionError:
        return 'Could not connect to server';
      case DioExceptionType.badResponse:
        return e.response?.statusMessage ?? 'Server error';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error';
    }
  }

  FailureKind _mapKind(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return FailureKind.offline;
    }
    return FailureKind.server;
  }
}
