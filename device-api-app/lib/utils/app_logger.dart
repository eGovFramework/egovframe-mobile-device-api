import 'package:flutter/foundation.dart';

/// Debug 빌드에서만 로그를 출력합니다. Release/Profile에서는 no-op.
void appLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

/// Debug 빌드에서만 오류 로그를 출력합니다.
void appLogError(String message, [Object? error]) {
  if (kDebugMode) {
    debugPrint(message);
    if (error != null) {
      debugPrint(error.toString());
    }
  }
}
