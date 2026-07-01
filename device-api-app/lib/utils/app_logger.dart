import 'package:flutter/foundation.dart';

/// 디버그 빌드에서만 출력되는 로거.
///
/// [kDebugMode]가 false인 릴리스 빌드에서는 로그가 출력되지 않으므로 민감 정보가 프로덕션 로그에 노출되지 않음
/// 비밀번호·토큰 등 민감 값은 로그에 포함 금지
class AppLogger {
  AppLogger._();

  static void d(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint(message);
      if (error != null) {
        debugPrint('  $error');
      }
      if (stackTrace != null) {
        debugPrint('$stackTrace');
      }
    }
  }
}
