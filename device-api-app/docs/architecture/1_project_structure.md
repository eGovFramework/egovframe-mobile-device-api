# 프로젝트 구조

본 프로젝트는 Clean Architecture 패턴을 적용하여 다음과 같은 구조를 가지고 있습니다.

## 프로젝트의 주요 모듈

프로젝트는 9개의 주요 기능 모듈을 포함합니다:

1. **Device Info** (기기 정보): 디바이스 하드웨어/소프트웨어 정보 조회
2. **GPS** (위치 서비스): Google Maps를 활용한 위치 정보 관리
3. **Accelerator** (가속도계): 3D 가속도 정보 시각화 및 저장
4. **File Management** (파일 관리): 파일 시스템 접근 및 관리
5. **File Read/Write** (파일 읽기/쓰기): 텍스트/JSON 파일 처리
6. **File Opener** (파일 열기): 다양한 파일 형식 열기
7. **Media** (미디어): 이미지/비디오 관리
8. **Interface** (인터페이스): UI 인터페이스 관리
9. **Network** (네트워크): 네트워크 정보 조회

각 모듈이 동일한 아키텍처 패턴을 따르므로, 코드 일관성과 유지보수성이 향상됩니다.

## 전체 프로젝트 구조

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

## 레이어별 설명

### 1. Domain Layer (`domain/`)

**역할**: 비즈니스 로직의 핵심

- **`entities/`**: 비즈니스 객체 (순수 Dart 클래스)
  - 예: `DeviceInfo`, `GpsInfo`, `AcceleratorInfo` 등
- **`repositories/`**: 데이터 접근 인터페이스 (추상 클래스)
  - 예: `DeviceRepository`, `GpsRepository` 등
- **`usecases/`**: 비즈니스 로직 실행 단위
  - 예: `DeviceUseCase`, `GpsUseCase` 등

**특징**:
- 외부 라이브러리 의존 없음
- 순수 Dart 코드
- 플랫폼 독립적

### 2. Data Layer (`data/`)

**역할**: 실제 데이터 소스 접근

- **`datasources/`**: 실제 데이터 소스 접근 (API, 로컬 파일 등)
  - 예: `DeviceService`, `GpsService` 등
- **`repositories/`**: Domain 레이어의 Repository 인터페이스 구현
  - 예: `DeviceRepositoryImpl`, `GpsRepositoryImpl` 등

**특징**:
- Domain 레이어의 인터페이스를 구현
- 외부 라이브러리 사용 가능 (HTTP, 파일 시스템 등)
- 데이터 변환 담당

### 3. Presentation Layer (`presentation/`)

**역할**: 사용자 인터페이스

- **`screens/`**: 화면 위젯 (Pages)
  - 예: `deviceInfo/deviceInfo_main.dart`, `gps/gps_main.dart` 등
- **`widgets/`**: 재사용 가능한 UI 컴포넌트
  - 예: `appbar.dart`, `button.dart`, `infobox.dart` 등
- **`resources/`**: 색상, 텍스트 스타일 등 UI 리소스
  - 예: `color_style.dart`, `text_style.dart` 등

**특징**:
- Domain 레이어에만 의존
- Flutter 프레임워크에 의존
- Use Case를 통해서만 비즈니스 로직 접근

### 4. 의존성 주입 (`di/`)

**역할**: 의존성 관리

- **`injection_container.dart`**: GetIt을 사용한 의존성 주입 설정
  - Repository 구현체 등록
  - Use Case 등록 및 Repository 주입

### 5. 유틸리티 (`utils/`)

**역할**: 공통 유틸리티 함수

- **`error_handler.dart`**: 통합 에러 핸들러
- **`permission_manager.dart`**: 권한 관리
- **`password_encryption.dart`**: 비밀번호 암호화
- **`server_connection_utils.dart`**: 서버 연결 유틸리티

### 6. Core (`core/`)

**역할**: 앱 전체 공통 핵심 로직

- **`device_id_service.dart`**: 디바이스 UUID 생성·저장·조회

### 7. 설정 (`config/`)

**역할**: 앱 설정

- **`app_config.dart`**: 서버 URL 등 앱 설정

---

## 모듈별 구조 예시

각 기능 모듈은 동일한 구조를 따릅니다.

### [예시] Device Info 모듈 구조

```
domain/
├── entities/
│   └── device_info.dart          # DeviceInfo 엔티티
├── repositories/
│   └── device_repository.dart    # DeviceRepository 인터페이스
└── usecases/
    └── device_usecase.dart        # DeviceUseCase

data/
├── datasources/
│   └── device_service.dart       # DeviceService (데이터 소스)
└── repositories/
    └── device_repository_impl.dart # DeviceRepositoryImpl

presentation/
└── screens/
    └── deviceInfo/
        ├── deviceInfo_main.dart   # DeviceInfo 메인 화면
        ├── deviceInfo_list.dart   # DeviceInfo 목록 화면
        ├── deviceInfo_detailed.dart # DeviceInfo 상세 화면
        └── deviceInfo_description.dart # DeviceInfo 설명 화면
```

### 데이터 흐름

```
1. Presentation (deviceInfo_main.dart)
   ↓ Use Case 호출
2. Domain Use Case (device_usecase.dart)
   ↓ Repository 인터페이스 사용
3. Data Repository Impl (device_repository_impl.dart)
   ↓ Data Source 호출
4. Data Source (device_service.dart)
   ↓ 실제 데이터 소스 접근
5. 실제 데이터 소스 (API, 로컬 파일 등)
```

---

