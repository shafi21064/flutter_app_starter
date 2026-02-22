// ──────────────────────────────────────────────────────────────
// lib/backend/iap_service.dart
// PURPOSE : In-App Purchase placeholder.
//           When enableIap = false, every method is a safe noop.
//           When enableIap = true, scaffold methods are provided
//           for you to integrate revenue_cat, in_app_purchase,
//           or another IAP package later.
//
// WHERE TO PLUG IAP LATER:
//   1. Add `in_app_purchase` or `purchases_flutter` to pubspec.yaml.
//   2. Implement the TODO blocks below.
//   3. Set enableIap = true in feature_flags.dart.
// ──────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/feature_flags.dart';
import '../core/logging/log.dart';
import '../core/result/result.dart';

/// Riverpod provider for [IapService].
final iapServiceProvider = Provider<IapService>((ref) {
  final flags = ref.watch(featureFlagsProvider);
  return IapService(enabled: flags.enableIap);
});

class IapService {
  IapService({required this.enabled});

  final bool enabled;

  /// Initialize the IAP plugin. Call once at app startup.
  Future<Result<void>> initialize() async {
    if (!enabled) {
      Log.d('IapService: disabled via feature flag – skipping init.');
      return const Success(null);
    }
    // TODO: Initialize your IAP SDK here.
    Log.i('IapService: initialized (placeholder).');
    return const Success(null);
  }

  /// Fetch available products from the store.
  Future<Result<List<String>>> fetchProducts() async {
    if (!enabled) {
      return const Success([]);
    }
    // TODO: Fetch real products from the store.
    Log.d('IapService: fetchProducts (placeholder).');
    return const Success(['com.enyx.starter.premium']);
  }

  /// Trigger a purchase flow for [productId].
  Future<Result<void>> purchase(String productId) async {
    if (!enabled) {
      return const Failure('In-app purchases are disabled',
          kind: FailureKind.featureDisabled);
    }
    // TODO: Trigger real purchase flow.
    Log.d('IapService: purchase $productId (placeholder).');
    return const Success(null);
  }

  /// Restore previous purchases.
  Future<Result<void>> restore() async {
    if (!enabled) {
      return const Success(null);
    }
    // TODO: Restore purchases.
    Log.d('IapService: restore (placeholder).');
    return const Success(null);
  }
}
