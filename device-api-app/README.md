# Flutter Device API Application

Flutter를 사용한 모바일 디바이스 정보 조회 및 관리 애플리케이션입니다. 
Clean Architecture 패턴을 적용하여 개발되었으며, 다양한 디바이스 기능을 통합적으로 관리할 수 있습니다.

## 목차

- [플러터란?](/docs/whatisflutter.md)
- [아키텍처](/docs/architecture/0_index.md)
  - [1. 프로젝트 구조](/docs/architecture/1_project_structure.md)
  - [2. 레이어 구조](/docs/architecture/2_layers.md)
  - [3. 의존성 역전 원칙](/docs/architecture/3_dependency_inversion.md)
  - [4. 실제 코드 예시](/docs/architecture/4_examples.md)
  - [5. 의존성 주입](/docs/architecture/5_dependency_injection.md)
  - [6. 에러 처리](/docs/architecture/6_error_handling.md)
- [Flutter 설치 가이드](/docs/settings.md)
- [처음 설정](/docs/gettingStarted.md)
- [Flutter 프로젝트 시작](/docs/project_start.md)
- [WebServer 실행](/docs/webserver.md)
- [애뮬레이터 설치 및 실행](/docs/emulator.md)
- [실기기에 Build 및 실행](/docs/device_build.md)
- [어플리케이션 19종 안내](/docs/device_applications.md)
  - [가속도계(Accelerator)](/docs/applications/accelerator.md)
  - [파일 관리(File Management)](/docs/applications/file_management.md)
  - [기기 정보(Device Info)](/docs/applications/device_info.md)
  - [문서 뷰어(File Opener)](/docs/applications/file_opener.md)
  - [파일 읽기/쓰기(File Read And Write)](/docs/applications/file_readwrite.md)
  - [위치 서비스(GPS)](/docs/applications/gps.md)
  - [인터페이스(Interface)](/docs/applications/interface.md)
  - [미디어(Media)](/docs/applications/media.md)
  - [네트워크(Network)](/docs/applications/network.md)
  - [바코드(Barcode)](/docs/applications/barcode.md)
  - [나침반(Compass)](/docs/applications/compass.md)
  - [연락처(Contacts)](/docs/applications/contacts.md)
  - [푸시(Push)](/docs/applications/push.md)
  - [소켓(Socket)](/docs/applications/socket.md)
  - [스트리밍(Streaming)](/docs/applications/streaming.md)
  - [얼굴 메시(Face Mesh)](/docs/applications/face_mesh.md)
  - [IoT](/docs/applications/iot.md)
  - [AI 채팅(AI Chat)](/docs/applications/ai_chat.md)
  - [SQLite Manager](/docs/applications/sqlite.md)

---

## 아키텍처

이 프로젝트는 **Clean Architecture** 패턴을 적용하고 있습니다.

```
┌─────────────────────────────────────┐
│        Presentation Layer           │ ← UI, Widgets, Screens
│        (Use Cases 사용)             │
├─────────────────────────────────────┤
│           Domain Layer              │ ← Entities, Use Cases, Repository Interfaces
│        (비즈니스 로직)               │
├─────────────────────────────────────┤
│            Data Layer               │ ← Data Sources, Repository Implementations
│        (데이터 접근)                 │
└─────────────────────────────────────┘
```

### 아키텍처 특징
- **의존성 역전**: Presentation Layer는 Domain Layer에만 의존
- **Use Case 패턴**: 모든 비즈니스 로직을 Use Case로 분리
- **의존성 주입**: Riverpod을 통한 런타임 의존성 관리
- **에러 처리**: UseCase sealed result + `showStatusToast` (l10n)
- **권한 관리**: PermissionManager 및 feature별 permission util

## 개발 환경

- **Flutter**: SDK 3.9.2 이상
- **Dart**: 3.9.2 이상
- **Android Studio**: 최신 버전 (권장)
- **Xcode**: 16.3 이상 (iOS 개발 시)
- **VS Code**: 최신 버전 (선택사항)

### 플랫폼별 최소 OS 버전
- **Android**: API Level 21 이상 (Android 5.0 Lollipop)
- **iOS**: iOS 15.0 이상

## 설치 및 실행

### 1. 필수 요구사항
- Flutter SDK 3.9.2 이상
- Android Studio 또는 VS Code
- iOS: Xcode (iOS 빌드 시)
- Android: Android SDK

### 2. 프로젝트 설정

압축을 풀고 IDE에서 `egovframe_mobile_deviceapi_app`을 연 뒤 맞추는 항목입니다. <br>
키 발급 절차는 [처음 설정](./docs/gettingStarted.md)에 있습니다.

#### 앱 기동에 필요한 설정

이 항목이 없으면 Android 또는 iOS 빌드가 멈추고 앱이 켜지지 않습니다.

- Flutter SDK와 Android SDK(Android) 또는 Xcode(iOS)
- 패키지 설치: `flutter pub get`
- Android `android/local.properties`. SDK가 설치되어 있으면 `flutter pub get`이 만듭니다
- `android/app/google-services.json`의 `package_name`이 `egovframework.mobile_deviceapi`일 것. 배포본의 자리표시자 파일이면 Firebase 키 없이 빌드됩니다

#### 선택 설정

없어도 앱은 켜집니다. 해당 기능만 동작하지 않습니다.

- Google Maps API 키: GPS 지도
- Firebase 앱 등록과 `google-services.json`, `ios/Runner/GoogleService-Info.plist` 교체: 푸시
- `lib/config/app_config.dart`의 `apiHost`: `flutter run`이 이 기본값으로 `device-api-web`에 연결
- `android/key.properties`: 릴리스 빌드. debug 실행에는 필요 없습니다

```bash
flutter pub get

# 코드 분석 실행 (선택사항)
flutter analyze
```

#### Message 중앙 관리
- l10n 으로 message 중앙 관리 및 국제화 처리 가능
- app_나라별 언어.arb 내부 파일 수정 
- `flutter gen-l10n` 실행 시 message 관련 파일 생성 됨 (ex - app_localizations_ko.dart)
- 파일별 기능 
  - l10n/app_*.arb : 언어별 message 원본
  - l10n/<application명>_message_keys.dart : 수동 작성 key 파일
  - l10n.yaml : gen-l10n 설정
  - l10n/app_localizations_*.dart : app_*.arb를 참고하여 자동생성되는 message 파일
  - l10n/app_localization.dart : l10n 진입점

#### 프로젝트 개발용 명령어
- riverpod build : `dart run build_runner build --delete-conflicting-outputs`
  - watch를 이용해 개발하는 동안 지속적으로 build할 필요 없음
    - `dart run build_runner watch --delete-conflicting-outputs`
  - riverpod을 적용한 파일의 *.g 파일(riverpod generator) 생성 (ex - device_controller.g.dart)
  - 삭제 
    - 캐시 삭제 : `dart run build_runner clean`
    - 파일까지 삭제 : `Get-ChildItem -Path lib -Recurse -Filter *.g.dart | Remove-Item -Force`
- 메시지 중앙 관리/국제화 처리 : `flutter gen-l10n`
  - 명령어 실행하지 않아도 build간 자동 생성
  - 삭제 : app_localizations*.dart 파일류 삭제



### 3. 실행
```bash
# Android
flutter run

# iOS
flutter run -d ios

# 특정 디바이스
flutter devices
flutter run -d <device-id>

# 릴리즈 빌드
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

#### 기타
- GPS Application 사용을 위해서는 Google MAP API Key 발급이 필요합니다
  - [Google Map API Key 발급 방법](./docs/applications/gps.md)
  
- 로컬 환경이 아닌 환경에서 개발 및 배포하는 경우 아래 네트워크 환경에 대한 설정이 추가적으로 필요합니다.
아래 가이드를 참조하여 설정을 진행하시기 바랍니다.
[README](./docs/project_start.md)

## 서버 연동

### 서버 URL 설정

#### 서버 URL 변경
- `flutter run`은 `lib/config/app_config.dart`의 `apiHost` `defaultValue`와 `apiPort`로 접속합니다.
- 개발 PC 주소가 다르면 그 `defaultValue`를 수정합니다. 엔드포인트는 `/acl`, `/gps`, `/aic` 등 기능별 prefix 입니다.

### 개발 환경 HTTP 접근 설정

debug 빌드만 루프백 HTTP를 허용합니다. 릴리스 빌드는 HTTPS만 허용합니다. 허용 호스트와 공기계에서 사설 IP를 추가하는 위치는 [local과 운영 실행](./docs/run_profiles.md)을 봅니다.

## 권한 설정

### Android (`android/app/src/main/AndroidManifest.xml`)

#### 위치 권한
```xml
<!-- 정밀 위치 정보 (GPS) - GPS 기능 사용 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<!-- 대략적인 위치 정보 (네트워크 기반) - GPS 기능 사용 -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- 백그라운드 위치 접근 - 백그라운드에서 위치 추적 시 필요 -->
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

#### 카메라 및 미디어 권한
```xml
<!-- 카메라 접근 - 사진 촬영 기능 사용 -->
<uses-permission android:name="android.permission.CAMERA" />
<!-- 오디오 녹음 - 비디오 녹화 시 오디오 포함 -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<!-- 외부 저장소 읽기 - 갤러리 접근, 파일 읽기 -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<!-- 외부 저장소 쓰기 - 파일 저장, 미디어 저장 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<!-- 미디어 이미지 읽기 (Android 13+) - 갤러리에서 이미지 선택 -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<!-- 미디어 비디오 읽기 (Android 13+) - 갤러리에서 비디오 선택 -->
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<!-- 미디어 오디오 읽기 (Android 13+) - 오디오 파일 접근 -->
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

#### 네트워크 권한
```xml
<!-- 인터넷 접근 - 서버 통신, 파일 다운로드/업로드 -->
<uses-permission android:name="android.permission.INTERNET" />
<!-- 네트워크 상태 확인 - 네트워크 연결 상태 모니터링 -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<!-- WiFi 상태 확인 - WiFi 정보 조회 -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<!-- 네트워크 상태 변경 - 네트워크 연결 상태 변경 감지 -->
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<!-- WiFi 상태 변경 - WiFi 연결 관리 -->
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
```

#### 기타 권한
```xml
<!-- 연락처 읽기 - 연락처 정보 조회 -->
<uses-permission android:name="android.permission.READ_CONTACTS" />
<!-- 패키지 쿼리 - 외부 앱 실행 (파일 열기 기능) -->
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
<!-- Google Play Services - Google Maps 사용 -->
<uses-permission android:name="com.google.android.providers.gsf.permission.READ_GSERVICES" />
```

### iOS (`ios/Runner/Info.plist`)

#### 위치 권한
```xml
<!-- 앱 사용 중 위치 접근 - GPS 기능 사용 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>위치 정보를 수집하기 위해 위치 접근이 필요합니다.</string>
<!-- 항상 위치 접근 (앱 사용 중 + 백그라운드) - 백그라운드 위치 추적 시 필요 -->
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>위치 정보를 수집하기 위해 위치 접근이 필요합니다.</string>
<!-- 항상 위치 접근 (iOS 10 이하 호환) -->
<key>NSLocationAlwaysUsageDescription</key>
<string>백그라운드에서도 위치 정보를 수집하기 위해 위치 접근이 필요합니다.</string>
```

#### 카메라 및 미디어 권한
```xml
<!-- 카메라 접근 - 사진 촬영 기능 사용 -->
<key>NSCameraUsageDescription</key>
<string>사진 촬영을 위해 카메라 접근이 필요합니다.</string>
<!-- 마이크 접근 - 비디오 녹화 시 오디오 포함 -->
<key>NSMicrophoneUsageDescription</key>
<string>오디오 녹음을 위해 마이크 접근이 필요합니다.</string>
<!-- 사진 라이브러리 읽기 - 갤러리에서 이미지/비디오 선택 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>갤러리에서 사진을 선택하기 위해 접근이 필요합니다.</string>
<!-- 사진 라이브러리 쓰기 - 촬영한 사진을 갤러리에 저장 -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>촬영한 사진을 갤러리에 저장하기 위해 접근이 필요합니다.</string>
```

#### 파일 접근 권한
```xml
<!-- 문서 폴더 접근 - 파일 관리 기능 사용 -->
<key>NSDocumentsFolderUsageDescription</key>
<string>파일 관리를 위해 문서 폴더에 접근이 필요합니다.</string>
<!-- 파일 제공자 도메인 접근 - 파일 공유 기능 -->
<key>NSFileProviderDomainUsageDescription</key>
<string>파일 공유를 위해 파일 제공자 도메인에 접근이 필요합니다.</string>
```

#### 기타 권한
```xml
<!-- 연락처 접근 - 연락처 정보 조회 -->
<key>NSContactsUsageDescription</key>
<string>이 앱은 연락처 개수를 확인하기 위해 연락처에 접근합니다.</string>
```

## 사용된 패키지

### 핵심 패키지
```yaml
dependencies:
  # GPS 및 위치 서비스
  geolocator: ^10.1.0
  google_maps_flutter: ^2.13.1
  
  # 센서 및 가속도계
  sensors_plus: ^4.0.2
  
  # 미디어 기능
  image_picker: ^1.0.7
  video_player: ^2.8.2
  
  # 파일 관리
  path_provider: ^2.1.2
  file_picker: ^8.0.0+1
  open_file: ^3.3.2
  
  # 네트워크 및 통신
  http: ^1.5.0
  connectivity_plus: ^6.0.3
  network_info_plus: ^5.0.1
  
  # 디바이스 정보
  device_info_plus: ^12.2.0
  package_info_plus: ^8.0.0
  
  # 권한 관리
  permission_handler: ^11.2.0
  
  # 연락처 접근
  flutter_contacts: ^1.1.8+1
  
  # UI
  flutter_svg: ^2.0.10+1
  
  # 설정 저장
  shared_preferences: ^2.2.2

  # 인터페이스 세션·SQLite 비밀번호
  flutter_secure_storage: ^9.2.4
  bcrypt: ^1.1.3

  # 상태 관리·의존성 주입 (Riverpod)
  flutter_riverpod: 3.0.3
  riverpod_annotation: 3.0.3

  # URL 실행
  url_launcher: ^6.2.5

  # 푸시
  firebase_core: ^3.15.2
  firebase_messaging: ^15.2.10
  flutter_local_notifications: ^18.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  riverpod_generator: 3.0.3
  build_runner: ^2.7.0
```

전체 목록은 `pubspec.yaml`과 [device_applications.md](docs/device_applications.md) 를 보면 됩니다. `get_it` 은 쓰지 않습니다.

## 프로젝트 구조

`domain/`·`data/`는 `presentation/screens`와 같이 **feature-first**로 구성합니다.
공유 타입은 `domain/shared/`에 둡니다.

```
lib/
├── config/                         # 앱 설정·SQLite 스키마
├── data/                           # 데이터 레이어 (feature-first)
│   ├── gps/
│   │   ├── datasources/            # gps_service, sqlite, server connection
│   │   └── repositories/           # remote / sqlite / facade impl
│   ├── deviceInfo/
│   ├── accelerator/
│   └── ...                         # 기타 feature 동일 패턴
├── domain/                         # 도메인 레이어 (feature-first)
│   ├── shared/
│   │   └── entities/               # app_item, server_connection_result
│   ├── gps/
│   │   ├── entities/
│   │   ├── repositories/           # 인터페이스
│   │   └── usecases/
│   ├── deviceInfo/
│   └── ...
├── presentation/
│   ├── resources/
│   ├── screens/                    # feature별 UI (gps, deviceInfo, ...)
│   └── widgets/                    # 공통 위젯
├── di/                             # Riverpod providers
├── utils/
└── main.dart
```

### 주요 파일 설명

#### 설정 파일
- `lib/config/app_config.dart`: 서버 URL 등 앱 전역 설정

#### 데이터 레이어
- `data/{feature}/datasources/`: 외부 데이터 소스 (API, SQLite, 센서 등)
- `data/{feature}/repositories/`: Repository 인터페이스의 구현체

#### 도메인 레이어
- `domain/{feature}/entities/`: 비즈니스 엔티티 (순수 Dart 클래스)
- `domain/{feature}/repositories/`: Repository 인터페이스 정의
- `domain/{feature}/usecases/`: 비즈니스 로직 (Use Case 패턴)
- `domain/shared/entities/`: feature 간 공유 엔티티

#### 프레젠테이션 레이어
- `presentation/resources/`: 색상, 텍스트 스타일, 텍스트 서비스
- `presentation/screens/`: 각 기능별 화면
- `presentation/widgets/`: 재사용 가능한 위젯

#### 유틸리티
- `utils/error_handler.dart`: 통합 에러 처리
- `utils/permission_manager.dart`: 권한 관리 통합 처리
- `utils/server_connection_utils.dart`: 서버 연결 확인 및 처리

## 기능 설명 데이터 구조

각 애플리케이션의 기능 설명은 다음 둘 중 하나입니다.

- **정본 (AI Chat / IoT / Face Mesh / File Management)**: `*FunctionPage` + l10n (`lib/l10n/app_*.arb`)
- **일부 기존 화면**: `FeatureGuidePage` + `data/feature_data.json`

신규 화면은 Face Mesh처럼 l10n FunctionPage를 따릅니다. 자세한 내용은 [presentation/11_flutter_practices.md](docs/presentation/11_flutter_practices.md) 를 보면 됩니다.

---
자세한 내용은 [목차](#목차) 내 게시글에서 확인하실 수 있습니다.