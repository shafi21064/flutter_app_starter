import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/log.dart';

/// Provider for the [NotificationService].
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// A service that manages local and remote (FCM) notifications.
class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  bool get _isFirebaseInitialized => Firebase.apps.isNotEmpty;

  /// Initializes the notification system.
  Future<void> initialize() async {
    // 1. Initialize Local Notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    try {
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
    } catch (e) {
      Log.e(
        'Failed to initialize local notifications. '
        'If you just added the plugin, try running "flutter clean" and then "flutter run" to rebuild native components.',
        error: e,
      );
    }

    // 2. Setup FCM Listeners
    if (_isFirebaseInitialized) {
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpenedApp);
    }

    // 3. Re-check/Request initial permissions (silent if already granted)
    await requestPermissions();

    Log.i('Notification system initialized.');
  }

  /// Triggered when the user taps on a local notification.
  void _onNotificationTapped(NotificationResponse response) {
    Log.i('Local notification tapped: ${response.payload}');
    // Use deepLinkServiceProvider or GoRouter to navigate if needed.
  }

  /// Triggered when the app is in foreground and an FCM message arrives.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    Log.i('FCM foreground message received: ${message.notification?.title}');

    // On Android/iOS, foreground notifications are NOT shown by default.
    // We show a local notification to provide the experience.
    if (message.notification != null) {
      await showLocalNotification(
        title: message.notification?.title ?? 'Notification',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Triggered when an FCM notification launches the app from background/terminated.
  void _handleNotificationOpenedApp(RemoteMessage message) {
    Log.i('App opened via FCM notification: ${message.notification?.title}');
    // Handle navigation logic here.
  }

  /// Requests the necessary notification permissions.
  Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      // Trigger native Apple permission dialog
      if (_isFirebaseInitialized) {
        final settings = await _fcm.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        return settings.authorizationStatus == AuthorizationStatus.authorized;
      }
      return true;
    } else if (Platform.isAndroid) {
      // For Android 13+, handle the 'Post Notifications' permission
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        return status.isGranted;
      }
    }
    return true;
  }

  /// Shows a local notification immediately.
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Main notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  /// Returns the current FCM push token.
  Future<String?> getFcmToken() async {
    if (!_isFirebaseInitialized) return null;
    try {
      return await _fcm.getToken();
    } catch (e) {
      Log.w('Could not retrieve FCM token: $e');
      return null;
    }
  }
}
