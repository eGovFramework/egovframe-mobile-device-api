import 'dart:math';

import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 기기 식별용 UUID v4 생성·저장·조회 서비스.
/// 서버 API 호출 시 기기별 데이터 격리 기준 값으로 사용됩니다.
class DeviceIdService {
  DeviceIdService._();

  static const String _secureStorageKey = 'device_install_id';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: false),
  );

  static final RegExp _uuidV4Regex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  static Future<String> getDeviceId() async {
    try {
      final stored = await _storage.read(key: _secureStorageKey);
      if (stored != null && stored.isNotEmpty && _isUuidV4(stored)) {
        return stored;
      }

      if (stored != null && stored.isNotEmpty) {
        appLog('DeviceIdService: 저장된 ID가 UUID v4가 아니어서 재생성합니다');
      }

      final deviceId = _generateUuidV4();
      await _storage.write(key: _secureStorageKey, value: deviceId);
      return deviceId;
    } catch (e) {
      appLogError('DeviceIdService.getDeviceId 실패', e);
      throw StateError('기기 식별 정보를 저장소에서 읽지 못했습니다.');
    }
  }

  static bool _isUuidV4(String value) => _uuidV4Regex.hasMatch(value);

  static String _generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
