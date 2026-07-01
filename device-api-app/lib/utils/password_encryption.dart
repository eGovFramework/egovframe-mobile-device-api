import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Interface REST API용 비밀번호 해시.
/// SHA-256(userId || password) 결과를 Base64 로 반환
/// 서버는 이 해시값을 DB에 그대로 저장·비교
class PasswordEncryption {
  static String encryptPassword(String password, String userId) {
    if (password.isEmpty) {
      return '';
    }

    final input = utf8.encode(userId) + utf8.encode(password);
    final digest = sha256.convert(input);
    return base64.encode(digest.bytes);
  }
}