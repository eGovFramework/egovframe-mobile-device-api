# Flutter Device API Application

Flutter를 사용한 모바일 디바이스 정보 조회 및 관리 애플리케이션입니다. 
Clean Architecture 패턴을 적용하여 개발되었으며, 다양한 디바이스 기능을 통합적으로 관리할 수 있습니다.

## 목차

- [플러터란?](/docs/whatisflutter.md)
- [아키텍처](/docs/architecture/0_index.md)
  - [1. 프로젝트 구조](/docs/architecture/project_structure.md)
  - [2. 레이어 구조](/docs/architecture/2_layers.md)
  - [3. 의존성 역전 원칙](/docs/architecture/3_dependency_inversion.md)
  - [4. 실제 코드 예시](/docs/architecture/4_examples.md)
  - [5. 의존성 주입](/docs/architecture/5_dependency_injection.md)
  - [6. 에러 처리](/docs/architecture/6_error_handling.md)
- [Flutter 설치 가이드](/docs/settings.md)
- [Flutter 프로젝트 시작](/docs/project_start.md)
- [WebServer 실행](/docs/webserver.md)
- [애뮬레이터 설치 및 실행](/docs/emulator.md)
- [실기기에 Build 및 실행](/docs/device_build.md)
- 어플리케이션 9종 안내
  - [가속도계(Accelerator)](/docs/applications/accelerator.md)
  - [파일 관리(File Management)](/docs/applications/file_management.md)
  - [기기 정보(Device Info)](/docs/applications/device_info.md)
  - [문서 뷰어(File Opener)](/docs/applications/file_opener.md)
  - [파일 읽기/쓰기(File Read And Write)](/docs/applications/file_readwrite.md)
  - [위치 서비스(GPS)](/docs/applications/gps.md)
  - [인터페이스(Interface)](/docs/applications/interface.md)
  - [미디어(Media)](/docs/applications/media.md)
  - [네트워크(Network)](/docs/applications/network.md)

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
- **의존성 주입**: GetIt을 통한 런타임 의존성 관리
- **에러 처리**: 통합된 ErrorHandler로 일관된 에러 관리
- **권한 관리**: PermissionManager를 통한 통합 권한 처리

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
- Google Maps API 키 (GPS 기능 사용 시)

### 2. 프로젝트 설정
```bash
# 프로젝트 클론
git clone <repository-url>
cd flutter_device

# 패키지 설치
flutter pub get

# 코드 분석 실행 (선택사항)
flutter analyze
```


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

## 서버 연동

### 서버 URL 설정

#### 서버 URL 변경
- `lib/config/app_config.dart`: 기본 서버 URL 설정
- 기본적으로 `baseUrl`이 localhost로 연결 (dev와 prod로 나눠서도 URL 설정 가능)
- 각 데이터 소스에서 API 엔드포인트 확인

### 개발 환경 HTTP 접근 설정

개발 환경에서 HTTP를 사용하는 서버에 접근하기 위해 다음 설정이 필요합니다.
운영 환경으로 배포하는 경우에는 아래 설정들을 주석 처리 또는 제거하세요.

#### Android 설정
1. **네트워크 보안 설정 파일**: `android/app/src/main/res/xml/network_security_config.xml`
   - 개발 서버 IP에 대한 HTTP 접근 허용 설정
   - 운영 환경 배포시에는 `android/app/src/main/AndroidManifest.xml`에서
     `application` 태그에서 `android:networkSecurityConfig` 속성을 제거하거나 주석 처리

2. **AndroidManifest.xml**: `android/app/src/main/AndroidManifest.xml`
   - `application` 태그에 `android:networkSecurityConfig="@xml/network_security_config"` 속성 추가

#### iOS 설정
- **Info.plist**: `ios/Runner/Info.plist`
  - `NSAppTransportSecurity` → `NSExceptionDomains`에 개발 서버 IP 추가
  - 운영 환경 배포시 `<key>NSExceptionDomains</key>` 관련 설정 주석 또는 제거

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
  
  # 의존성 주입
  get_it: ^7.6.4
  
  # WebView
  webview_flutter: ^4.4.2
  
  # URL 실행
  url_launcher: ^6.2.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 프로젝트 구조

```
lib/
├── config/                    # 앱 설정
│   └── app_config.dart       # 서버 URL 등 앱 설정
├── data/                      # 데이터 레이어
│   ├── datasources/          # 데이터 소스 (API, 로컬 파일 등)
│   │   ├── device_service.dart
│   │   ├── gps_service.dart
│   │   ├── accelerometer_service.dart
│   │   ├── file_management_service.dart
│   │   ├── file_readwrite_service.dart
│   │   ├── file_opener_service.dart
│   │   ├── interface_service.dart
│   │   ├── media_service.dart
│   │   └── network_service.dart
│   └── repositories/         # Repository 구현체
│       ├── device_repository_impl.dart
│       ├── gps_repository_impl.dart
│       ├── accelerator_repository_impl.dart
│       ├── file_readwrite_repository_impl.dart
│       ├── fileopener_repository_impl.dart
│       ├── interface_repository_impl.dart
│       ├── media_repository_impl.dart
│       └── network_repository_impl.dart
├── domain/                   # 도메인 레이어
│   ├── entities/            # 비즈니스 엔티티
│   │   ├── device_info.dart
│   │   ├── gps_info.dart
│   │   ├── accelerator_info.dart
│   │   ├── file_readwrite_info.dart
│   │   ├── file_opener_info.dart
│   │   ├── interface_info.dart
│   │   ├── media_info.dart
│   │   └── network_info.dart
│   ├── repositories/        # Repository 인터페이스
│   │   ├── device_repository.dart
│   │   ├── gps_repository.dart
│   │   ├── accelerator_repository.dart
│   │   ├── file_readwrite_repository.dart
│   │   ├── fileopener_repository.dart
│   │   ├── interface_repository.dart
│   │   ├── media_repository.dart
│   │   └── network_repository.dart
│   └── usecases/           # 비즈니스 로직 (Use Cases)
│       ├── device_usecase.dart
│       ├── gps_usecase.dart
│       ├── accelerator_usecase.dart
│       ├── file_readwrite_usecase.dart
│       ├── fileopener_server_usecase.dart
│       ├── interface_usecase.dart
│       ├── media_usecase.dart
│       └── network_usecase.dart
├── presentation/            # 프레젠테이션 레이어
│   ├── resources/          # 리소스 (색상, 텍스트 스타일)
│   │   ├── color_style.dart
│   │   ├── text_style.dart
│   │   └── text_service.dart
│   ├── screens/           # 화면 (Pages)
│   │   ├── accelerator/
│   │   ├── deviceInfo/
│   │   ├── fileMgmt/
│   │   ├── fileopener/
│   │   ├── fileReadWrite/
│   │   ├── gps/
│   │   ├── interface/
│   │   ├── media/
│   │   └── network/
│   └── widgets/           # 재사용 가능한 위젯
│       ├── appbar.dart
│       ├── button.dart
│       ├── feature_description.dart
│       ├── infobox.dart
│       └── ...
├── core/                   # 앱 공통 핵심 로직
│   └── device_id_service.dart
├── di/                     # 의존성 주입 (GetIt)
│   └── injection_container.dart
├── utils/                  # 유틸리티 함수
│   ├── error_handler.dart
│   ├── permission_manager.dart
│   ├── password_encryption.dart
│   └── server_connection_utils.dart
└── main.dart              # 앱 진입점
```

### 주요 파일 설명

#### 설정 파일
- `lib/config/app_config.dart`: 서버 URL 등 앱 전역 설정

#### 데이터 레이어
- `data/datasources/`: 외부 데이터 소스 (API 호출, 파일 시스템 접근 등)
- `data/repositories/`: Repository 인터페이스의 구현체

#### 도메인 레이어
- `domain/entities/`: 비즈니스 엔티티 (순수 Dart 클래스)
- `domain/repositories/`: Repository 인터페이스 정의
- `domain/usecases/`: 비즈니스 로직 (Use Case 패턴)

#### 프레젠테이션 레이어
- `presentation/resources/`: 색상, 텍스트 스타일, 텍스트 서비스
- `presentation/screens/`: 각 기능별 화면
- `presentation/widgets/`: 재사용 가능한 위젯

#### 유틸리티
- `utils/error_handler.dart`: 통합 에러 처리
- `utils/permission_manager.dart`: 권한 관리 통합 처리
- `utils/server_connection_utils.dart`: 서버 연결 확인 및 처리

## 기능 설명 데이터 구조

각 애플리케이션의 기능 설명은 `data/feature_data.json` 파일에 JSON 형식으로 저장되어 있습니다.

### JSON 구조
```json
{
  "applicationName": {
    "title1": {
      "title": "제목",
      "content": "설명 내용"
    },
    "featureDescription": {
      "title": "기능 설명 제목",
      "items": [
        "기능 1 설명",
        "기능 2 설명"
      ]
    },
    "usageGuide": {
      "title": "사용 가이드",
      "content": "가이드 내용"
    }
  }
}
```

각 애플리케이션의 `*_function.dart` 파일에서 `TextService`를 통해 이 데이터를 로드하여 표시합니다.

---
자세한 내용은 [목차](#목차) 내 게시글에서 확인하실 수 있습니다.