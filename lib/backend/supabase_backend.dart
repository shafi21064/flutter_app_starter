// ──────────────────────────────────────────────────────────────
// lib/backend/supabase_backend.dart
// PURPOSE : Typed wrapper around the Supabase client exposing
//           common DB, RPC, edge-function, and storage operations.
//           All methods return Result<T> – never null on error.
//
// HOW TO EXTEND:
//   Add domain-specific helpers (e.g. fetchProfiles) that call
//   the generic methods below.
// ──────────────────────────────────────────────────────────────

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/env.dart';
import '../core/logging/log.dart';
import '../core/result/result.dart';

/// Riverpod provider for the Supabase backend wrapper.
final supabaseBackendProvider = Provider<SupabaseBackend>((ref) {
  return SupabaseBackend();
});

/// Thin, typed wrapper around the Supabase client.
class SupabaseBackend {
  SupabaseClient get _client => Supabase.instance.client;

  // ── Database helpers ──────────────────────────────────────

  /// SELECT rows from [table].
  Future<Result<List<Map<String, dynamic>>>> select(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
  }) async {
    try {
      var query = _client.from(table).select(columns);
      filters?.forEach((key, value) {
        query = query.eq(key, value);
      });
      final data = await query;
      return Success(List<Map<String, dynamic>>.from(data));
    } catch (e, st) {
      Log.e('Supabase SELECT $table failed', error: e, stack: st);
      return Failure('Failed to fetch data from $table',
          kind: FailureKind.server, exception: e);
    }
  }

  /// INSERT a row into [table].
  Future<Result<Map<String, dynamic>>> insert(
    String table,
    Map<String, dynamic> values,
  ) async {
    try {
      final data =
          await _client.from(table).insert(values).select().single();
      return Success(Map<String, dynamic>.from(data));
    } catch (e, st) {
      Log.e('Supabase INSERT $table failed', error: e, stack: st);
      return Failure('Failed to insert into $table',
          kind: FailureKind.server, exception: e);
    }
  }

  /// UPDATE rows in [table] matching [filters].
  Future<Result<List<Map<String, dynamic>>>> update(
    String table,
    Map<String, dynamic> values, {
    required Map<String, dynamic> filters,
  }) async {
    try {
      var query = _client.from(table).update(values);
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
      final data = await query.select();
      return Success(List<Map<String, dynamic>>.from(data));
    } catch (e, st) {
      Log.e('Supabase UPDATE $table failed', error: e, stack: st);
      return Failure('Failed to update $table',
          kind: FailureKind.server, exception: e);
    }
  }

  /// DELETE rows from [table] matching [filters].
  Future<Result<void>> delete(
    String table, {
    required Map<String, dynamic> filters,
  }) async {
    try {
      var query = _client.from(table).delete();
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
      await query;
      return const Success(null);
    } catch (e, st) {
      Log.e('Supabase DELETE $table failed', error: e, stack: st);
      return Failure('Failed to delete from $table',
          kind: FailureKind.server, exception: e);
    }
  }

  // ── RPC ───────────────────────────────────────────────────

  /// Call a Postgres function via RPC.
  Future<Result<dynamic>> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final data = await _client.rpc(functionName, params: params);
      return Success(data);
    } catch (e, st) {
      Log.e('Supabase RPC $functionName failed', error: e, stack: st);
      return Failure('RPC call $functionName failed',
          kind: FailureKind.server, exception: e);
    }
  }

  // ── Edge Functions ────────────────────────────────────────

  /// Invoke a Supabase Edge Function.
  Future<Result<String>> invokeEdgeFunction(
    String functionName, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final res = await _client.functions.invoke(
        functionName,
        body: body,
      );
      return Success(res.data.toString());
    } catch (e, st) {
      Log.e('Edge function $functionName failed', error: e, stack: st);
      return Failure('Edge function $functionName failed',
          kind: FailureKind.server, exception: e);
    }
  }

  // ── Storage ───────────────────────────────────────────────

  /// Upload bytes to a Supabase Storage bucket.
  Future<Result<String>> uploadBytes(
    String bucket,
    String path,
    Uint8List bytes, {
    String contentType = 'application/octet-stream',
  }) async {
    if (!Env.hasSupabaseKeys) {
      return const Failure('Supabase not configured',
          kind: FailureKind.featureDisabled);
    }
    try {
      final fullPath =
          await _client.storage.from(bucket).uploadBinary(path, bytes,
              fileOptions: FileOptions(contentType: contentType));
      return Success(fullPath);
    } catch (e, st) {
      Log.e('Storage upload to $bucket/$path failed', error: e, stack: st);
      return Failure('Upload failed',
          kind: FailureKind.server, exception: e);
    }
  }
}
