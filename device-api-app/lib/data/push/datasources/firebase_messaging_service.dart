import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/firebase_options.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

typedef FcmMessageHandler = Future<void> Function(RemoteMessage message);
typedef FcmTokenHandler = void Function(String token);

/// FCM 백그라운드 수신 핸들러 (top-level 필수)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  appLog(
    'FCM background message: ${message.messageId} / ${message.notification?.title}',
  );
}

/// Firebase Cloud Messaging 초기화·토큰·메시지 수신
class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static bool _firebaseReady = false;
  static String? _fcmToken;
  static FcmMessageHandler? _foregroundMessageHandler;
  static FcmTokenHandler? _onTokenRefresh;

  static bool get isFirebaseReady => _firebaseReady;

  static String? get fcmToken => _fcmToken;

  static Future<bool> initializeFirebase() async {
    if (_firebaseReady) {
      return true;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      _firebaseReady = true;
      return true;
    } catch (e, stackTrace) {
      appLog('FirebaseMessagingService.initializeFirebase failed: $e');
      if (kDebugMode) {
        appLog(stackTrace.toString());
      }
      return false;
    }
  }

  static void setForegroundMessageHandler(FcmMessageHandler handler) {
    _foregroundMessageHandler = handler;
  }

  static void setTokenRefreshHandler(FcmTokenHandler handler) {
    _onTokenRefresh = handler;
  }

  static void registerMessageListeners() {
    FirebaseMessaging.onMessage.listen((message) async {
      appLog('FCM foreground message: ${message.messageId}');
      final handler = _foregroundMessageHandler;
      if (handler != null) {
        await handler(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      appLog('FCM opened from notification: ${message.messageId}');
    });

    _messaging.onTokenRefresh.listen((token) {
      appLog('FCM token refreshed');
      _fcmToken = token;
      _onTokenRefresh?.call(token);
    });
  }

  static Future<bool> requestNotificationPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final authorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (!authorized) {
        appLog('FirebaseMessagingService: iOS permission denied');
        return false;
      }
      return true;
    }

    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus != AuthorizationStatus.denied;
  }

  static Future<String?> fetchFcmToken() async {
    if (!_firebaseReady) {
      final ready = await initializeFirebase();
      if (!ready) { 
        return null;
      }
    }

    try {
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          appLog('FirebaseMessagingService: APNS token not ready yet');
        }
      }

      final token = await _messaging.getToken();
      _fcmToken = token;
      return token;
    } catch (e) {
      appLog('FirebaseMessagingService.fetchFcmToken failed: $e');
      return null;
    }
  }

  static Future<RemoteMessage?> getInitialMessage() =>
      _messaging.getInitialMessage();
}
