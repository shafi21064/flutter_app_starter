// ──────────────────────────────────────────────────────────────
// lib/main.dart
// PURPOSE : Application entry point. Initialises Supabase (if
//           keys are present), SharedPreferences, deep links,
//           connectivity, and then launches the app inside a
//           ProviderScope with overrides.
//
// HOW TO RUN:
//   # Dev (no Supabase – shows MissingKeysPage):
//   flutter run
//
//   # Dev/Prod with Supabase:
//   # 1. Fill values in .env
//   # 2. flutter run
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/deep_links/deep_link_service.dart';
import 'core/logging/log.dart';
import 'core/notifications/notification_service.dart';
import 'core/storage/kv_store.dart';

/// Top-level background message handler for FCM.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();
  Log.i("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 0. Load .env ────────────────────────────────────────
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    Log.w('.env file not found or failed to load. Using defaults.');
  }

  // ── 0.1 Firebase & Notifications ──────────────────────────
  if (!Env.isDev) {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      Log.i('Firebase initialized for ${Env.flavor} flavor.');
    } catch (e, st) {
      Log.e(
        'Firebase initialization failed (Is config missing?)',
        error: e,
        stack: st,
      );
    }
  } else {
    Log.i('Skipping Firebase initialization for dev flavor.');
  }

  // ── 1. SharedPreferences ──────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final kvStore = KvStore(prefs);

  // ── 2. Supabase (skip if keys missing) ────────────────────
  if (Env.hasSupabaseKeys) {
    try {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
        // authOptions: const FlutterAuthClientOptions(
        //   authFlowType: AuthFlowType.pkce,
        // ),
      );
      Log.i('Supabase initialized for ${Env.flavor} flavor.');
    } catch (e, st) {
      Log.e('Supabase init failed', error: e, stack: st);
    }
  } else {
    Log.w('Supabase keys missing – app will show MissingKeysPage.');
  }

  // ── 3. Run the app ────────────────────────────────────────
  runApp(
    ProviderScope(
      overrides: [kvStoreProvider.overrideWithValue(kvStore)],
      child: const EnyxStarterApp(),
    ),
  );
}

/// Called once from app.dart after first frame to start deep link
/// listener and any other post-launch services.
void startPostLaunchServices(ProviderContainer container) {
  container.read(deepLinkServiceProvider).startListening();
  container.read(notificationServiceProvider).initialize();
}
