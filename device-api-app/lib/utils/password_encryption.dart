import 'package:bcrypt/bcrypt.dart';

/// SQLite에 저장하는 인터페이스 비밀번호 해시.
/// 서버 계정은 서버가 BCrypt로 저장하고, 앱은 평문을 보낸다.
class PasswordEncryption {
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static bool matches(String password, String hashed) {
    if (password.isEmpty || hashed.isEmpty) {
      return false;
    }
    try {
      return BCrypt.checkpw(password, hashed);
    } catch (_) {
      return false;
    }
  }
}
