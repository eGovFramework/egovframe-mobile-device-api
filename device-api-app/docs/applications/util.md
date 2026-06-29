# 유틸리티 (Util)

## 개요

유틸리티 모듈은 앱 전체에서 공통으로 사용하는 핵심 기능을 제공합니다.<br> `DeviceIdService`는 기기를 식별하는 **UUID v4**를 생성·저장·조회하며, 서버 API 호출 시 기기별 데이터를 구분하는 기준 값으로 사용됩니다. <br>
앱 재설치 전까지 동일한 UUID가 유지되도록 `flutter_secure_storage`에 안전하게 보관합니다.

## 주요 기능

### 1. 기기 UUID 조회
- 앱 최초 실행 시 UUID v4를 생성하여 저장
- 이후 호출 시 저장된 UUID를 반환
- `getDeviceId()` 정적 메서드 하나로 조회 가능

### 2. UUID v4 형식 검증
- 저장된 값이 UUID v4 형식인지 정규식으로 검증
- 형식이 맞지 않으면 새 UUID를 재생성

### 3. 오류 시 기본값 반환
- Secure Storage 접근 실패 등 예외 발생 시 `unknown_device`를 반환
- 앱이 비정상 종료되지 않도록 방어적으로 처리

## 아키텍처 구조

### Core Layer
- **Service**: `DeviceIdService` (`lib/core/device_id_service.dart`)
  - 싱글톤 패턴의 정적 유틸리티 클래스
  - UUID v4 생성 (`_generateUuidV4`)
  - Secure Storage 읽기/쓰기
  - UUID v4 형식 검증 (`_isUuidV4`)

### 사용 위치

`DeviceIdService`는 독립 화면 없이 각 기능 모듈에서 직접 호출됩니다.

| 구분 | 파일 | 용도 |
|------|------|------|
| Data | `device_service.dart` | 기기 정보 수집 시 UUID 설정 |
| Data | `network_service.dart` | 네트워크 정보 전송 시 UUID 조회 |
| Data | `media_service.dart` | 미디어 서버 업로드 시 UUID 전달 |
| Data | `file_opener_service.dart` | 서버 파일 목록 조회·다운로드 시 UUID 전달 |
| Data | `interface_service.dart` | 인터페이스 API 호출 시 UUID 전달 |
| Presentation | `deviceInfo_detailed.dart` | 기기 정보 화면 UUID 표시·서버 연동 |
| Presentation | `gps_main.dart`, `gps_list.dart`, `gps_detail.dart` | GPS 데이터 서버 연동 |
| Presentation | `accelerator_info.dart`, `accelerator_list.dart`, `accelerator_detail.dart` | 가속도계 데이터 서버 연동 |
| Presentation | `network_detail.dart` | 네트워크 정보 삭제 시 UUID 전달 |
| Presentation | `media_main.dart`, `media_list.dart`, `media_detail.dart` | 미디어 서버 연동 |
| Presentation | `fileReadWrite_main.dart`, `filereadwrite_list.dart`, `filereadwrite_detail.dart` | 파일 읽기/쓰기 서버 연동 |

## 의존성

- `flutter_secure_storage: ^9.2.4`: UUID 안전 저장
- `dart:math`: `Random.secure()` 기반 UUID v4 생성

## 사용 방법

### 기본 호출

```dart
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';

final uuid = await DeviceIdService.getDeviceId();
```

### 동작 흐름

1. Secure Storage에서 `device_install_id` 키로 저장된 값을 읽습니다
3. 저장 값이 없거나 형식이 맞지 않으면 새 UUID v4를 생성
4. 생성한 UUID를 Secure Storage에 저장한 뒤 반환

### 서버 API 연동 예시

서버 목록 조회 시 UUID를 쿼리 파라미터로 전달합니다.

```
GET /fop/selectFileOpenerList.do?uuid={uuid}
```

서버 DB의 `UUID` 컬럼과 일치하는 데이터만 해당 기기에 반환됩니다.

## 주의사항

- UUID는 **앱 삭제 후 재설치** 시 새로 생성됩니다. Secure Storage 데이터도 함께 삭제되기 때문입니다
- Secure Storage 접근에 실패하면 `unknown_device`가 반환되며, 서버에서 기기별 데이터 구분이 되지 않을 수 있습니다
- iOS에서는 `device_info_plus`의 Android 전용 API를 사용하지 않습니다

## 보안 고려사항
이 프로젝트는 Flutter를 이용한 Mobile app을 만드는 샘플 프로젝트로, UUID는 **비밀번호가 아니라 기기 식별자**로 사용됩니다. <br>
서버는 `UUID` 값으로 데이터를 필터링할 뿐, 요청자가 해당 UUID의 실제 소유자인지 별도로 검증하지 않습니다. <br>
배포용 App 개발시에는 UUID를 단독적으로 사용하지 말고 JWT 토큰 등을 이용해 소유자 인증 방법을 추가해야합니다.


### 가이드 앱 vs 운영 서비스
| 항목 | 현재 가이드 앱 | 운영 서비스 권장 |
|------|----------------|------------------|
| 통신 | HTTP (로컬 개발) | **HTTPS** 필수 |
| UUID 역할 | 기기별 데이터 분리 | **식별자**로만 사용 |
| 인증 | 없음 | **JWT·세션·API Key** 등 |
| 서버 검증 | UUID 값 일치 여부만 확인 | 로그인 사용자 ↔ UUID **소유권 검증** |

## 기술적 특징

- **UUID v4 생성**: `Random.secure()`로 16바이트 난수를 생성하고, RFC 4122 v4 규격(버전·variant 비트)에 맞게 포맷합니다
- **형식 검증**: 정규식으로 UUID v4 패턴(`xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`)을 검증합니다
- **안전한 저장**: `flutter_secure_storage`를 사용하여 Keychain(iOS)·EncryptedSharedPreferences(Android)에 저장합니다
- **싱글톤 유틸리티**: private 생성자(`DeviceIdService._()`)로 인스턴스 생성을 막고, 정적 메서드만 제공합니다
- **앱 전역 공통 식별자**: Clean Architecture의 Core 레이어에 위치하며, Data·Presentation 레이어에서 공통으로 참조합니다
