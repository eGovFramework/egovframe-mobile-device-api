import 'dart:convert';

import 'package:crypto/crypto.dart';

/// 비밀번호 암호화 유틸리티 클래스
class PasswordEncryption {
  /// 비밀번호를 SHA-256으로 해시화
  /// 
  /// [password] 평문 비밀번호
  /// 반환: 해시화된 비밀번호 (hex 문자열)
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 비밀번호를 해시화하고 salt를 추가 (더 안전한 방법)
  /// 
  /// [password] 평문 비밀번호
  /// [salt] 솔트 값 (선택사항, 없으면 기본값 사용)
  /// 반환: 해시화된 비밀번호 (hex 문자열)
  static String hashPasswordWithSalt(String password, {String? salt}) {
    final saltValue = salt ?? 'egovframe_mobile_deviceapi_app_salt_2024';
    final combined = '$password$saltValue';
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

