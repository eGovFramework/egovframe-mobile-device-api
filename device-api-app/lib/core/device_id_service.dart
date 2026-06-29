import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceIdService {
  DeviceIdService._();

  static const String _secureStorageKey = 'device_install_id';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static final RegExp _uuidV4Regex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  static Future<String> getDeviceId() async {
    try {
      final stored = await _storage.read(key: _secureStorageKey);
      if (stored != null &&
          stored.isNotEmpty &&
          _isUuidV4(stored)) {
        return stored;
      }

      if (stored != null && stored.isNotEmpty) {
        debugPrint('DeviceIdService: 저장된 ID가 UUID v4가 아니어서 재생성합니다 ($stored)');
      }

      final deviceId = _generateUuidV4();
      await _storage.write(key: _secureStorageKey, value: deviceId);
      return deviceId;
    } catch (e) {
      debugPrint('DeviceIdService.getDeviceId 실패: $e');
      return 'unknown_device';
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
