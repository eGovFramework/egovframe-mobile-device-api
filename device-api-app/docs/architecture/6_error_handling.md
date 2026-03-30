# 에러 처리

프로젝트는 `ErrorHandler`를 통해 일관된 에러 처리를 제공합니다.

## 통합 에러 핸들러

### ErrorHandler 클래스

```dart
// utils/error_handler.dart
class ErrorHandler {
  /// 에러 타입 감지
  static ErrorType detectErrorType(dynamic error) {
    if (error is SocketException) return ErrorType.network;
    if (error is TimeoutException) return ErrorType.timeout;
    if (error is FormatException) return ErrorType.format;
    return ErrorType.unknown;
  }

  /// 에러 메시지 반환
  static String getErrorMessage(dynamic error, ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return '네트워크 연결을 확인해주세요.';
      case ErrorType.timeout:
        return '요청 시간이 초과되었습니다.';
      case ErrorType.format:
        return '데이터 형식이 올바르지 않습니다.';
      case ErrorType.unknown:
        return '알 수 없는 오류가 발생했습니다.';
      default:
        return '오류가 발생했습니다.';
    }
  }

  /// 에러 다이얼로그 표시
  static Future<void> showErrorDialog(
    BuildContext context,
    String message, {
    String? title,
    VoidCallback? onRetry,
    String? retryText,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? '오류'),
          content: Text(message),
          actions: [
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: Text(retryText ?? '다시 시도'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  /// 에러 로깅
  static void logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) {
    print('Error in $context: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
}

enum ErrorType {
  network,
  timeout,
  format,
  unknown,
}
```

---

## 실제 사용 예시

### Presentation Layer에서 사용

```dart
// presentation/screens/deviceInfo/deviceInfo_main.dart
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';

Future<void> _getDeviceInfo() async {
  setState(() => isLoading = true);
  try {
    deviceInfo = await _deviceUseCase.getDeviceInfo();
  } catch (e, stackTrace) {
    ErrorHandler.logError(e, null, context: 'DeviceInfoPage._getDeviceInfo');
    final errorType = ErrorHandler.detectErrorType(e);
    final errorMessage = ErrorHandler.getErrorMessage(e, errorType);
    await ErrorHandler.showErrorDialog(
      context,
      errorMessage,
      title: '디바이스 정보 조회 실패',
      onRetry: _getDeviceInfo,
      retryText: '다시 시도',
    );
  } finally {
    setState(() => isLoading = false);
  }
}
```

---

## 에러 타입별 처리

### 1. 네트워크 에러

```dart
try {
  deviceInfo = await _deviceUseCase.getDeviceInfo();
} on SocketException catch (e) {
  // 네트워크 연결 오류
  await ErrorHandler.showErrorDialog(
    context,
    '네트워크 연결을 확인해주세요.',
    title: '연결 오류',
    onRetry: _getDeviceInfo,
  );
}
```

### 2. 타임아웃 에러

```dart
try {
  deviceInfo = await _deviceUseCase.getDeviceInfo();
} on TimeoutException catch (e) {
  // 요청 시간 초과
  await ErrorHandler.showErrorDialog(
    context,
    '요청 시간이 초과되었습니다.',
    title: '시간 초과',
    onRetry: _getDeviceInfo,
  );
}
```

### 3. 포맷 에러

```dart
try {
  deviceInfo = await _deviceUseCase.getDeviceInfo();
} on FormatException catch (e) {
  // 데이터 형식 오류
  await ErrorHandler.showErrorDialog(
    context,
    '데이터 형식이 올바르지 않습니다.',
    title: '형식 오류',
  );
}
```

---

## 에러 처리 전략

### 1. 에러 타입별 처리

- **네트워크 에러**: 재시도 옵션 제공
- **타임아웃 에러**: 재시도 옵션 제공
- **포맷 에러**: 사용자에게 알림만 제공
- **알 수 없는 에러**: 로깅 후 사용자에게 알림

### 2. 에러 로깅

모든 에러는 로깅하여 나중에 분석할 수 있도록 합니다.

```dart
ErrorHandler.logError(e, stackTrace, context: 'DeviceInfoPage._getDeviceInfo');
```


## 에러 처리 흐름

```
1. 에러 발생 (Use Case, Repository 등)
   ↓
2. Presentation Layer에서 catch
   ↓
3. ErrorHandler.detectErrorType() - 에러 타입 감지
   ↓
4. ErrorHandler.getErrorMessage() - 사용자 친화적 메시지 생성
   ↓
5. ErrorHandler.showErrorDialog() - 사용자에게 표시
   ↓
6. ErrorHandler.logError() - 로깅 (선택적)
```