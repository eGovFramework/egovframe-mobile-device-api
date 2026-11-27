import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/push/datasources/firebase_messaging_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// FCM 토큰·푸시 수신 및 서버 HTTP 통신 (device-api-web /pus REST)
class PushService {
  PushService._();

  static const String _androidChannelId = 'egov_push_channel';
  static const String _androidChannelName = 'eGov Push Notifications';
  static const String _androidChannelDescription =
      'PushNotifications DeviceAPI FCM notifications';

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static bool _listenersRegistered = false;
  static String? _fcmTokenId;

  static bool get isInitialized => _initialized;

  static String? get fcmTokenId => _fcmTokenId;

  /// Firebase + FCM 토큰 발급 + 로컬 알림 채널 초기화
  static Future<bool> initializeNotifications() async {
    if (_initialized) {
      final token = await FirebaseMessagingService.fetchFcmToken();
      if (token != null && token.isNotEmpty) {
        _fcmTokenId = token;
        return true;
      }
    }

    final firebaseReady = await FirebaseMessagingService.initializeFirebase();
    if (!firebaseReady) {
      appLog('PushService.initializeNotifications: Firebase init failed');
      return false;
    }

    if (!_listenersRegistered) {
      FirebaseMessagingService.registerMessageListeners();
      FirebaseMessagingService.setForegroundMessageHandler(_showFcmNotification);
      FirebaseMessagingService.setTokenRefreshHandler((token) {
        _fcmTokenId = token;
      });
      _listenersRegistered = true;
    }

    if (!await _initializeLocalNotificationsPlugin()) {
      return false;
    }

    if (!await FirebaseMessagingService.requestNotificationPermission()) {
      appLog('PushService.initializeNotifications: FCM permission denied');
      return false;
    }

    if (Platform.isAndroid) {
      final androidImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidImpl?.requestNotificationsPermission();
      if (granted == false) {
        appLog('PushService.initializeNotifications: Android permission denied');
        return false;
      }
    }

    final token = await FirebaseMessagingService.fetchFcmToken();
    if (token == null || token.isEmpty) {
      appLog('PushService.initializeNotifications: FCM token unavailable');
      return false;
    }

    _fcmTokenId = token;
    _initialized = true;
    return true;
  }

  static Future<bool> _initializeLocalNotificationsPlugin() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final initialized = await _notificationsPlugin.initialize(
      settings: initSettings,
    );
    if (initialized != true) {
      appLog('PushService._initializeLocalNotificationsPlugin: plugin init failed');
      return false;
    }

    if (Platform.isAndroid) {
      final androidImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.createNotificationChannel(
        const AndroidNotificationChannel(
          _androidChannelId,
          _androidChannelName,
          description: _androidChannelDescription,
          importance: Importance.high,
        ),
      );
    }

    return true;
  }

  static Future<void> _showFcmNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? 'eGov Push';
    final body = notification?.body ?? message.data['msg']?.toString() ?? '';

    if (body.isEmpty && notification == null) {
      return;
    }

    await _showLocalNotification(
      title: title,
      body: body.isEmpty ? '새 푸시 메시지가 도착했습니다.' : body,
    );
  }

  /// 테스트 로컬 알림 표시 (FCM 연동 확인용)
  static Future<bool> showTestNotification({
    String title = 'eGov Push Test',
    String body = 'PushNotifications DeviceAPI FCM sample notification',
  }) async {
    if (!_initialized) {
      appLog('PushService.showTestNotification: not initialized');
      return false;
    }

    return _showLocalNotification(title: title, body: body);
  }

  static Future<bool> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: details,
      );
      return true;
    } catch (e) {
      appLog('PushService._showLocalNotification failed: $e');
      return false;
    }
  }

  static Future<String> getConnectionType() async {
    try {
      final result = await Connectivity().checkConnectivity();
      switch (result.first) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        default:
          return 'Unknown';
      }
    } catch (_) {
      return 'Unknown';
    }
  }

  static String _composeAndroidDeviceName(AndroidDeviceInfo info) {
    final brand = info.brand;
    final model = info.model;
    final manufacturer = info.manufacturer;

    if (brand.isNotEmpty && model.isNotEmpty) return '$brand $model';
    if (manufacturer.isNotEmpty && model.isNotEmpty) {
      return '$manufacturer $model';
    }
    if (model.isNotEmpty) return model;
    if (brand.isNotEmpty) return brand;
    if (manufacturer.isNotEmpty) return manufacturer;
    return 'Android Device';
  }

  static String _composeAndroidOsVer(AndroidDeviceInfo info) {
    final release = info.version.release;
    final sdkInt = info.version.sdkInt;
    if (release.isNotEmpty) return 'Android $release (API $sdkInt)';
    return 'Android API $sdkInt';
  }

  static String _composeIosOsVer(IosDeviceInfo info) {
    final version = info.systemVersion;
    return version.isNotEmpty ? 'iOS $version' : 'iOS';
  }

  /// 현재 디바이스 정보 수집 (PushDeviceInfo)
  static Future<PushDeviceInfo> collectPushDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    final tokenId =
        _fcmTokenId ?? FirebaseMessagingService.fcmToken ?? '';
    final ntwrkDeviceInfo = await getConnectionType();

    var osType = Platform.isAndroid
        ? 'Android'
        : Platform.isIOS
            ? 'iOS'
            : Platform.operatingSystem;
    var osVer = osType;
    var deviceNm = Platform.isAndroid
        ? 'Android Device'
        : Platform.isIOS
            ? 'iOS Device'
            : '${Platform.operatingSystem} Device';

    try {
      if (Platform.isAndroid) {
        final info = await deviceInfoPlugin.androidInfo;
        osType = 'Android';
        osVer = _composeAndroidOsVer(info);
        deviceNm = _composeAndroidDeviceName(info);
      } else if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        osType = 'iOS';
        osVer = _composeIosOsVer(info);
        deviceNm = info.name.isNotEmpty ? info.name : 'iOS Device';
      }
    } catch (e) {
      appLog('PushService.collectPushDeviceInfo device info failed: $e');
    }

    return PushDeviceInfo(
      sn: 0,
      uuid: uuid,
      ntwrkDeviceInfo: ntwrkDeviceInfo,
      osVer: osVer,
      deviceNm: deviceNm,
      useYn: 'Y',
      osType: osType,
      tokenId: tokenId,
    );
  }

  /// 서버: 푸시 디바이스 등록
  static Future<Map<String, dynamic>?> postPushDevice(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getPushUrl('/insertPushDevice.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('PushService.postPushDevice failed: $e');
      return null;
    }
  }

  /// 서버: 푸시 디바이스 목록 조회
  static Future<List<Map<String, dynamic>>> fetchPushDeviceList(
    String uuid,
  ) async {
    if (uuid.isEmpty) {
      return [];
    }
    final uri = Uri.parse(
      AppConfig.getPushUrl('/selectPushDeviceList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('pushDeviceList');
    } catch (e) {
      appLog('PushService.fetchPushDeviceList failed: $e');
      return [];
    }
  }

  /// 서버: 현재 기기 UUID 기준 푸시 메시지 이력 조회 (PUSH_MESSAGE)
  static Future<List<Map<String, dynamic>>> fetchPushMessageList(
    String uuid,
  ) async {
    if (uuid.isEmpty) {
      return [];
    }

    final uri = Uri.parse(
      AppConfig.getPushUrl('/selectPushMessageList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('pushMessageList');
    } catch (e) {
      appLog('PushService.fetchPushMessageList failed: $e');
      return [];
    }
  }

  /// 서버: UUID 기준 푸시 디바이스 삭제
  static Future<Map<String, dynamic>?> deletePushDevice(String uuid) async {
    final uri = Uri.parse(
      AppConfig.getPushUrl('/deletePushDevice.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('PushService.deletePushDevice failed: $e');
      return null;
    }
  }
}
