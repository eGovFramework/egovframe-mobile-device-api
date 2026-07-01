# 에러 처리

프로젝트는 **`ErrorHandler`**(사용자 UI)와 **`AppLogger`**(개발자 로그)로 역할을 분리해 일관된 에러 처리를 제공합니다.

| 구분 | 클래스 | 역할 |
|------|--------|------|
| 사용자 UI | `ErrorHandler` | 친화적 메시지 생성, 다이얼로그 표시 |
| 개발자 로그 | `AppLogger` | `kDebugMode`에서만 `debugPrint` 출력 |

---

## AppLogger

릴리스 빌드에서는 로그가 출력되지 않습니다. 비밀번호·토큰 등 민감 정보는 로그에 포함하지 마세요.

```dart
// utils/app_logger.dart
AppLogger.d('초기화된 경로: $_currentPath');
AppLogger.e('요청 실패', error, stackTrace);
```

---

## ErrorHandler API

### ErrorType

```dart
enum ErrorType {
  network,
  permission,
  location,
  camera,
  storage,
  file,
  unknown,
}
```

### 주요 메서드

| 메서드 | 용도 |
|--------|------|
| `detectErrorType(error)` | 예외 문자열 기반 타입 감지 |
| `getErrorMessage(error, type)` | 타입별 사용자 메시지 |
| `messageFor(error)` | `detectErrorType` + `getErrorMessage` 단축 |
| `logError(error, stackTrace, {context})` | 개발 로그 (`AppLogger.e` 위임) |
| `handleException(context, error, {...})` | 로그 + `messageFor` + 에러 다이얼로그 |
| `showErrorDialog(context, message, {...})` | 비즈니스/검증 실패 등 직접 메시지 표시 |
| `showSuccessDialog` / `showSuccessSnackBar` | 성공 알림 |

에러 다이얼로그는 `showStatusDialog`(variant: `error`)를 사용합니다.

```dart
// utils/error_handler.dart (요약)
static String messageFor(Object error) {
  return getErrorMessage(error, detectErrorType(error));
}

static void logError(dynamic error, StackTrace? stackTrace, {String? context}) {
  final prefix = context != null ? '[$context] ' : '';
  AppLogger.e('${prefix}Error', error, stackTrace);
}

static Future<void> handleException(
  BuildContext context,
  Object error, {
  StackTrace? stackTrace,
  String? logContext,
  String? title,
}) async {
  logError(error, stackTrace, context: logContext);
  await showErrorDialog(context, messageFor(error), title: title);
}
```

---

## Presentation Layer 패턴

### 1. 액션/상세 화면 — 예외 catch

로그와 다이얼로그를 한 번에 처리합니다.

```dart
Future<void> _getDeviceInfo() async {
  setState(() => isLoading = true);
  try {
    deviceInfo = await _deviceUseCase.getDeviceInfo();
  } catch (e, stackTrace) {
    if (mounted) {
      await ErrorHandler.handleException(
        context,
        e,
        stackTrace: stackTrace,
        logContext: 'DeviceInfoPage._getDeviceInfo',
        title: '디바이스 정보 조회 실패',
      );
    }
  } finally {
    setState(() => isLoading = false);
  }
}
```

### 2. 목록 화면 — state에 에러 메시지

다이얼로그 대신 화면 내 메시지를 표시할 때 사용합니다.

```dart
catch (e, stackTrace) {
  ErrorHandler.logError(e, stackTrace, context: 'NetworkListPage._loadList');
  setState(() {
    _errorMessage = ErrorHandler.messageFor(e);
    _isLoading = false;
  });
}
```

### 3. 비즈니스/검증 실패 — 직접 메시지

예외가 아닌 로그인 실패, 빈 입력 등은 `showErrorDialog`를 직접 호출합니다.

```dart
if (interfaceInfo == null) {
  await ErrorHandler.showErrorDialog(
    context,
    '아이디 또는 비밀번호가 올바르지 않습니다.',
  );
  return;
}
```

### 4. 내부 루프/백그라운드 — 로그만

UI 없이 실패 건수만 집계하는 경우 로그만 남깁니다.

```dart
} catch (e, stackTrace) {
  ErrorHandler.logError(e, stackTrace, context: 'MediaScreen._deleteSelectedFiles');
  totalFailCount++;
}
```

### 5. Data Layer / 유틸 — AppLogger 또는 logError

UI가 없는 계층에서는 `ErrorHandler.logError` 또는 `AppLogger.e`를 사용합니다.

---

## 금지 사항

- **`print()` / `debugPrint()`** — `AppLogger` 사용
- **사용자에게 `$e` / `e.toString()` 노출** — `messageFor()` 또는 직접 작성한 메시지 사용
- **화면별 `_showErrorDialog` 래퍼** — `ErrorHandler.showErrorDialog` 직접 호출

---

## 에러 처리 흐름

```
1. 에러 발생 (Use Case, Repository, Service 등)
   ↓
2. Presentation Layer에서 catch (e, stackTrace)
   ↓
3-A. handleException  → logError + messageFor + showErrorDialog
3-B. 목록 화면        → logError + messageFor → state
3-C. 비즈니스 실패    → showErrorDialog(직접 메시지)
   ↓
4. AppLogger.e (kDebugMode에서만 출력)
```

---

## 에러 타입별 메시지 예시

`detectErrorType`은 예외 문자열을 분석해 아래 타입을 반환합니다.

| 타입 | 감지 키워드 예 | 메시지 예 |
|------|----------------|-----------|
| `network` | network, connection, timeout, http | 네트워크 연결을 확인해주세요. |
| `permission` | permission, denied | 권한이 거부되었습니다. |
| `location` | location, gps, service | GPS 설정을 확인해주세요. |
| `camera` | camera | 카메라 오류가 발생했습니다. |
| `storage` | storage, file, directory | 저장소 오류가 발생했습니다. |
| `file` | corrupted, not found, too large | 파일 처리 중 오류가 발생했습니다. |
| `unknown` | (기타) | 알 수 없는 오류가 발생했습니다. |

네트워크 타입은 404, 500, timeout 등 세부 상황에 따라 `getErrorMessage`가 다른 문구를 반환합니다.
