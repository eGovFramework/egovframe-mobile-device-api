# 바코드 스캐너 (Barcode)

## 개요

바코드 기능은 모바일 디바이스의 BarcodeScanner API(`flutter_zxing`)를 활용하여 QR·바코드를 인식하고, eGovFrame 웹 서버(`/bar`) 또는 로컬 SQLite와 연계하여 바코드 정보를 저장·조회·삭제하는 샘플입니다.

## 주요 기능

### 1. 바코드 스캔
- `flutter_zxing`(ZXing C++ 엔진)의 `ReaderWidget`으로 QR 코드 및 바코드를 카메라로 실시간 인식합니다
- 인식이 끝나면 스캐너가 닫히고 메인 화면에 결과가 표시됩니다

### 2. 바코드 정보 저장
- 스캔 결과를 `BARCODE_INFO` 테이블에 저장합니다
- 코드 유형, 코드 값, 사용 여부, 스캔 시각을 포함합니다

### 3. 바코드 정보 목록
- 서버 MySQL 또는 로컬 SQLite에서 저장된 기록을 조회합니다

### 4. 바코드 정보 삭제
- 목록에서 항목을 선택해 서버/SQLite에서 삭제합니다

### 5. SQLite 연동
- MySQL `BARCODE_INFO`와 동일 스키마로 로컬 CRUD를 지원합니다

## 아키텍처 구조

### Domain Layer
- **Entity**: `BarcodeInfo`
  - `sn`: 일련번호
  - `uuid`: 디바이스 고유 식별자
  - `codeType`: 코드 유형 (`QR Code`, `Code128`, `EAN13` 등 ZXing 포맷명)
  - `codeText`: 인식된 코드 값
  - `useYn`: 사용 여부
  - `codeDt`: 스캔 시각
- **Repository**: `BarcodeRepository` (인터페이스)
- **UseCase**: `BarcodeUseCase`

### Data Layer
- **Service**: `BarcodeService`
  - 스캔 설정(`scanCodeFormat`, `scanCropPercent`, `scanDelay`) 제공
  - ZXing `Code` → `BarcodeScan` 변환(`scanFromCode`), 포맷명 변환(`formatCodeType`)
  - 서버 REST(`/bar`) 전송
- **Repository Implementation**: `BarcodeRepositoryImpl`
  - 서버 또는 SQLite 저장소 선택

### Presentation Layer
- **Screen**: `BarcodePage`
  - 스캔 결과 표시 (`BarcodeOverview`)
  - 전체 화면 스캐너 (`BarcodeScanPage`)
  - 저장 및 목록 조회

## 의존성

- `flutter_zxing: 2.2.1`: QR·바코드 카메라 인식 (ZXing C++ / Apache-2.0, ML Kit 미사용)
- `camera: ^0.11.0`: `flutter_zxing`이 사용하는 카메라 프리뷰·프레임 스트림
- `permission_handler: ^11.2.0`: 카메라 권한
- `http: ^1.5.0`: 서버 통신

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **바코드 스캐너**로 진입합니다. 연결 카드에서 서버 또는 SQLite를 고른 뒤 스캔·저장을 진행합니다.

>**사용 방법**
- '주요기능' 탭에서 **바코드 스캔**을 누르면 전체 화면 카메라 스캐너가 열립니다
- QR 코드 또는 바코드를 카메라에 비추면 인식 후 메인으로 돌아와 결과가 표시됩니다
- **정보 저장**으로 스캔한 정보를 서버 또는 SQLite에 저장합니다
- **정보 목록**으로 저장된 기록을 확인하고, 항목을 선택해 삭제할 수 있습니다

### 스캔 화면
카메라 미리보기 위에 스캔 오버레이가 표시됩니다. 오버레이의 가이드 영역은 `flutter_zxing`이 실제로 디코딩하는 중앙 정사각 크롭 영역(`BarcodeService.scanCropPercent`)과 동일하게 그려집니다. 인식이 성공하면 자동으로 닫힙니다.

### 목록·삭제
저장된 `codeType`, `codeText`, 시각을 목록에서 확인합니다. 선택한 항목은 논리 삭제(`USEYN`) 또는 SQLite 삭제로 처리됩니다.

## 주의사항

- 카메라 권한이 필요합니다
- 서버 저장을 쓰려면 `device-api-web`이 실행 중이어야 하며 `AppConfig.baseUrl`이 `/bar`를 가리켜야 합니다
- 에뮬레이터는 카메라가 없거나 가상 카메라만 있을 수 있어 실기기 테스트가 더 안정적입니다

## 기술적 특징

- **실시간 인식**: `flutter_zxing`이 `camera` 이미지 스트림 프레임을 ZXing C++ 네이티브로 디코딩 (별도 isolate 처리)
- **웹 경로**: `/bar` (`BARCODE_INFO`)
- **연결 모드**: 서버와 SQLite를 화면에서 전환 (`BarcodeConnectionResolver`)
- **연결 확인**: `GET /bar/selectBarcodeInfoList.do`에 기기 uuid를 붙입니다. 이 API는 uuid가 없으면 400을 반환하므로, uuid 없는 확인은 연결 실패로 보입니다. 확인 응답의 목록은 쓰지 않고, 목록 화면이 같은 URL을 다시 조회합니다. 공통 규칙은 [DeviceApiClient](../architecture/9_device_api_client.md)를 본다.
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
