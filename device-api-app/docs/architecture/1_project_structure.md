# 프로젝트 구조

본 프로젝트는 Clean Architecture 패턴을 적용하여 다음과 같은 구조를 가지고 있습니다.

## 프로젝트의 주요 모듈

프로젝트는 앱 목록 기준 **19개 기능**을 포함합니다. 대표 모듈:

1. **Device Info** (기기 정보): 디바이스 하드웨어/소프트웨어 정보 조회
2. **GPS** (위치 서비스): Google Maps를 활용한 위치 정보 관리
3. **Accelerator** (가속도계): 3D 가속도 정보 시각화 및 저장
4. **File Management / ReadWrite / Opener**: 파일 시스템·문서
5. **Media / Streaming**: 이미지·비디오
6. **Interface / Network / Barcode / Compass / Contacts / Push / Socket / IoT**
7. **Face Mesh**: MediaPipe로 온디바이스 얼굴 랜드마크 검출
8. **AI Chat**: device-api-web `/aic` → egovframe-ai-rag 질의, 세션 이력
9. **SQLite Manager**: 로컬 DB 생성·편집

전체 목록과 의존성은 [device_applications.md](../device_applications.md) 를 보면 됩니다.

각 모듈이 동일한 아키텍처 패턴을 따르므로, 코드 일관성과 유지보수성이 향상됩니다.

**예외:** File Management·SQLite Manager는 서버 연결이 없습니다. File Management는 UseCase/Repository는 두되 `connection_*` 위젯은 두지 않습니다. UI 정본은 AI Chat / IoT / Face Mesh 입니다. 안내는 [presentation/11_flutter_practices.md](../presentation/11_flutter_practices.md) 를 보면 됩니다.

## 폴더 구성 원칙 (feature-first)

레이어(`domain` / `data` / `presentation`)는 유지하되, 각 레이어 내부는
`presentation/screens`와 같이 **기능(feature) 단위로 물리 분리**합니다.

```
domain/{feature}/entities|repositories|usecases/
data/{feature}/datasources|repositories|models/
presentation/screens/{feature}/state|view|view_model|widgets/
domain/shared/entities/   # feature 간 공유 타입
domain/shared/json_read.dart  # entity fromJson 공용 파서
```

Entity 직렬화·state 작성 규칙은 [7_entity_conventions.md](./7_entity_conventions.md)를 따른다.

폴더명은 screens와 동일하게 맞춥니다 (`gps`, `deviceInfo`, `fileReadWrite`, `aiChat` 등).

## 전체 프로젝트 구조

```
lib/
├── config/                         # 앱 설정·SQLite 스키마
│   ├── app_config.dart
│   └── {feature}_sqlite_schema.dart
├── data/                           # 데이터 레이어 (feature-first)
│   ├── gps/
│   │   ├── datasources/
│   │   │   ├── gps_service.dart
│   │   │   ├── gps_sqlite_service.dart
│   │   │   └── gpsServerConnectionService.dart
│   │   └── repositories/
│   │       ├── gps_repository_impl.dart
│   │       ├── gps_remote_repository_impl.dart
│   │       └── gps_sqlite_repository_impl.dart
│   ├── deviceInfo/
│   ├── accelerator/
│   └── ...                         # 기타 feature 동일 패턴
├── domain/                         # 도메인 레이어 (feature-first)
│   ├── shared/
│   │   ├── entities/
│   │   │   ├── app_item.dart
│   │   │   └── server_connection_result.dart
│   │   └── json_read.dart          # fromJson 공용 파서
│   ├── gps/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── deviceInfo/
│   └── ...
├── presentation/                   # 프레젠테이션 레이어
│   ├── resources/
│   ├── screens/                    # feature별 UI
│   │   ├── accelerator/
│   │   ├── aiChat/
│   │   ├── barcode/
│   │   ├── deviceInfo/
│   │   ├── faceMesh/
│   │   ├── fileMgmt/
│   │   ├── fileopener/
│   │   ├── fileReadWrite/
│   │   ├── gps/
│   │   ├── interface/
│   │   ├── iot/
│   │   ├── media/
│   │   ├── network/
│   │   ├── sqlite/
│   │   └── ...
│   └── widgets/                    # 공통 위젯
├── di/                             # Riverpod providers
│   ├── providers.dart
│   └── {feature}_connection_provider.dart
├── utils/
└── main.dart
```

## 레이어별 설명

### 1. Domain Layer (`domain/`)

**역할**: 비즈니스 로직의 핵심

- **`{feature}/entities/`**: 비즈니스 객체 (순수 Dart 클래스)
  - 예: `domain/deviceInfo/entities/device_info.dart`
- **`{feature}/repositories/`**: 데이터 접근 인터페이스 (추상 클래스)
  - 예: `domain/gps/repositories/gps_repository.dart`
- **`{feature}/usecases/`**: 비즈니스 로직 실행 단위
  - 예: `domain/gps/usecases/gps_usecase.dart`
- **`shared/entities/`**: feature 간 공유 엔티티
  - 예: `server_connection_result.dart`, `app_item.dart`

**특징**:
- 외부 라이브러리 의존 없음
- 순수 Dart 코드
- 플랫폼 독립적

### 2. Data Layer (`data/`)

**역할**: 실제 데이터 소스 접근

- **`{feature}/datasources/`**: 실제 데이터 소스 접근 (API, SQLite, 센서 등)
  - 예: `data/deviceInfo/datasources/device_service.dart`
- **`{feature}/repositories/`**: Domain 레이어의 Repository 인터페이스 구현
  - 예: `data/gps/repositories/gps_repository_impl.dart`

**특징**:
- Domain 레이어의 인터페이스를 구현
- 외부 라이브러리 사용 가능 (HTTP, 파일 시스템 등)
- 데이터 변환 담당

### 3. Presentation Layer (`presentation/`)

**역할**: 사용자 인터페이스

- **`screens/{feature}/`**: 화면 위젯 (Pages)
  - 예: `deviceInfo/view/deviceInfo_main.dart`, `gps/view/gps_main.dart`
- **`widgets/`**: 재사용 가능한 UI 컴포넌트
- **`resources/`**: 색상, 텍스트 스타일 등 UI 리소스

**특징**:
- Domain 레이어에만 의존
- Flutter 프레임워크에 의존
- Use Case를 통해서만 비즈니스 로직 접근

### 4. 의존성 주입 (`di/`)

**역할**: 의존성 관리

- **`providers.dart`**: Riverpod 기반 Service·Repository·UseCase 등록
- **`{feature}_connection_provider.dart`**: feature별 연결 모드(로컬/서버) 상태

### 5. 유틸리티 (`utils/`)

**역할**: 공통 유틸리티 함수

- **`error_handler.dart`**: 통합 에러 핸들러
- **`permission_manager.dart`**: 권한 관리
- **`device_uuid_util.dart`**: 디바이스 UUID 유틸리티
- **`password_encryption.dart`**: SQLite 인터페이스 비밀번호의 BCrypt 해시와 검증
- **`server_connection_utils.dart`**: 서버 연결 유틸리티

### 6. 설정 (`config/`)

**역할**: 앱 설정

- **`app_config.dart`**: 서버 URL 등 앱 설정
- **`{feature}_sqlite_schema.dart`**: feature별 SQLite 스키마

---

## 모듈별 구조 예시

각 기능 모듈은 동일한 구조를 따릅니다.

### [예시] Device Info 모듈 구조

```
domain/deviceInfo/
├── entities/
│   └── device_info.dart
├── repositories/
│   └── device_repository.dart
└── usecases/
    └── device_usecase.dart

data/deviceInfo/
├── datasources/
│   └── device_service.dart
└── repositories/
    └── device_repository_impl.dart

presentation/screens/deviceInfo/
├── state/
├── view/
├── view_model/
└── widgets/
```

### 데이터 흐름

```
1. Presentation (screens/deviceInfo/...)
   ↓ Use Case 호출
2. Domain Use Case (domain/deviceInfo/usecases/device_usecase.dart)
   ↓ Repository 인터페이스 사용
3. Data Repository Impl (data/deviceInfo/repositories/device_repository_impl.dart)
   ↓ Data Source 호출
4. Data Source (data/deviceInfo/datasources/device_service.dart)
   ↓ 실제 데이터 소스 접근
5. 실제 데이터 소스 (API, 로컬 파일 등)
```

---
