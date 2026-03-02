// ──────────────────────────────────────────────────────────────
// lib/core/deep_links/deep_link_service.dart
// PURPOSE : Listens to incoming OS deep links (Universal Links /
//           App Links) and hands them to Supabase for completing
//           OAuth callbacks and password-reset flows.
//
// SETUP REQUIRED (platform-level):
//
//   iOS (Info.plist + Associated Domains):
//     - Add your Supabase callback URL scheme to CFBundleURLTypes, e.g.
//       <key>CFBundleURLSchemes</key>
//       <array><string>com.enyx.starter</string></array>
//     - Add Associated Domain: applinks:<your-supabase-project>.supabase.co
//
//   Android (AndroidManifest.xml):
//     <intent-filter android:autoVerify="true">
//       <action android:name="android.intent.action.VIEW"/>
//       <category android:name="android.intent.category.DEFAULT"/>
//       <category android:name="android.intent.category.BROWSABLE"/>
//       <data android:scheme="https"
//             android:host="<your-supabase-project>.supabase.co"
//             android:pathPrefix="/auth/v1/callback"/>
//     </intent-filter>
//
// HOW TO EXTEND:
//   - Handle non-auth deep links by inspecting the URI path
//     before forwarding to Supabase.
// ──────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../logging/log.dart';

/// Provider that manages incoming deep links.
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService();
});

class DeepLinkService {
  StreamSubscription<Uri>? _sub;
  bool _isListening = false;

  /// Start listening for deep links.
  /// Safe to call even when Supabase is not initialized – will
  /// simply log and ignore links in that case.
  void startListening() {
    if (_isListening) return;
    if (!Env.hasSupabaseKeys) {
      Log.w('DeepLinkService: Supabase keys missing – skipping listener.');
      return;
    }

    final appLinks = AppLinks();

    _sub = appLinks.uriLinkStream.listen(
      (Uri uri) {
        Log.i('Deep link received: $uri');
        _handleLink(uri);
      },
      onError: (Object err) {
        Log.e('Deep link error', error: err);
      },
    );

    // Also check the initial / cold-start link.
    appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        Log.i('Initial deep link: $uri');
        _handleLink(uri);
      }
    }).catchError((Object e) {
      Log.e('Failed to get initial deep link', error: e);
    });
    _isListening = true;
  }

  Future<void> _handleLink(Uri uri) async {
    try {
      // Supabase SDK will parse the fragment/query for tokens.
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
    } on AuthException catch (e) {
      // Common in email-verification flows when no PKCE flow state exists.
      if (e.toString().contains('flow_state_not_found')) {
        Log.w('DeepLinkService: ignored flow_state_not_found for uri: $uri');
        return;
      }
      Log.e('Supabase deep-link auth exception', error: e);
    } catch (e, st) {
      Log.e('Supabase deep-link handling failed', error: e, stack: st);
    }
  }

  void dispose() {
    _sub?.cancel();
    _isListening = false;
  }
}
