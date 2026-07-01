import 'package:egovframe_mobile_deviceapi_app/utils/password_encryption.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Interface 로그인 자격 증명을 flutter_secure_storage에 저장
// 비밀번호는 API 전송과 동일한 해시값(SHA-256+userId, Base64)만 저장
class InterfaceCredentialStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _keyUserId = 'userId';
  static const String _keyPassword = 'password';
  static const String _keyLogin = 'login';
  static const String _keyLoginTime = 'loginTime';

  static Future<void> save(String userId, String plainPassword) async {
    final clientHash = PasswordEncryption.encryptPassword(plainPassword, userId);
    final now = DateTime.now();

    await _storage.write(key: _keyPassword, value: clientHash);
    await _storage.write(key: _keyUserId, value: userId);
    await _storage.write(key: _keyLogin, value: 'true');
    await _storage.write(key: _keyLoginTime, value: now.toIso8601String());
  }

  static Future<({
    String userId,
    String hashedPassword,
    DateTime? loginTime,
  })?> readSession() async {
    final loginStatus = await _storage.read(key: _keyLogin);
    final userId = await _storage.read(key: _keyUserId);
    final hashedPassword = await _storage.read(key: _keyPassword);
    final loginTimeStr = await _storage.read(key: _keyLoginTime);

    if (loginStatus == null || userId == null || hashedPassword == null) {
      return null;
    }

    DateTime? loginTime;
    if (loginTimeStr != null) {
      try {
        loginTime = DateTime.parse(loginTimeStr);
      } catch (_) {
        loginTime = null;
      }
    }

    return (
      userId: userId,
      hashedPassword: hashedPassword,
      loginTime: loginTime,
    );
  }

  static Future<void> clear() async {
    await _storage.delete(key: _keyPassword);
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyLogin);
    await _storage.delete(key: _keyLoginTime);
  }
}
