// ──────────────────────────────────────────────────────────────
// lib/core/connectivity/connectivity_controller.dart
// PURPOSE : Tracks device online/offline state via Riverpod.
//           Other providers and UI widgets watch this to block
//           network calls or show an offline banner.
//
// HOW TO EXTEND:
//   - Add wifi-vs-mobile distinction if needed.
// ──────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../logging/log.dart';

/// `true` when the device has network connectivity.
final connectivityProvider =
    StateNotifierProvider<ConnectivityController, bool>((ref) {
      return ConnectivityController();
    });

class ConnectivityController extends StateNotifier<bool> {
  ConnectivityController() : super(true) {
    _init();
  }

  late final StreamSubscription<List<ConnectivityResult>> _sub;

  Future<void> _init() async {
    // Check initial state.
    final initial = await Connectivity().checkConnectivity();
    state = _isOnline(initial);

    // Listen for changes.
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final online = _isOnline(results);
      if (state != online) {
        Log.i('Connectivity changed → ${online ? "ONLINE" : "OFFLINE"}');
        state = online;
      }
    });
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
