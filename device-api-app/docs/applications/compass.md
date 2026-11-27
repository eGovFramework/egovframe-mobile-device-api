# 나침반 (Compass)

## 개요

나침반 기능은 모바일 디바이스의 Compass API를 활용하여 방위각 정보를 조회하고, eGovFrame 웹 서버(`/cps`) 또는 로컬 SQLite와 연계하여 나침반 정보를 저장·조회·삭제하는 샘플입니다.

## 주요 기능

### 1. 나침반 정보 조회
- `flutter_compass`로 방위각(0~360°)을 실시간 조회합니다
- 나침반 다이얼 UI가 디바이스 방향에 따라 회전합니다

### 2. 나침반 정보 저장
- 조회된 정보를 `COMPASS` 테이블에 저장합니다
- 방위각(`drc`), 정확도(`accrcy`), UUID, 타임스탬프를 포함합니다

### 3. 나침반 정보 목록
- 서버 MySQL 또는 로컬 SQLite에서 기록을 조회합니다

### 4. 나침반 정보 삭제
- 목록에서 항목을 선택해 서버/SQLite의 해당 기록을 삭제합니다

### 5. SQLite 연동
- MySQL `COMPASS`와 동일 스키마로 로컬 CRUD를 지원합니다

## 아키텍처 구조

### Domain Layer
- **Entity**: `CompassInfo`
  - `sn`: 일련번호
  - `uuid`: 디바이스 고유 식별자
  - `drc`: 방위각
  - `accrcy`: 정확도
  - `useYn`: 사용 여부
  - `timestamp`: 타임스탬프
- **Repository**: `CompassRepository` (인터페이스)
- **UseCase**: `CompassUseCase`

### Data Layer
- **Service**: `CompassService`
  - 나침반 센서 스트림
  - 서버 REST(`/cps`) 전송
- **Repository Implementation**: `CompassRepositoryImpl`

### Presentation Layer
- **Screen**: `CompassPage`
  - 실시간 방위각·다이얼 (`CompassOverview`)
  - 저장 및 목록 조회

## 의존성

- `flutter_compass: ^0.8.1`: 방위각 센서
- `http: ^1.5.0`: 서버 통신

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **나침반**으로 진입합니다.

>**사용 방법**
- '주요기능' 탭에서 **나침반 조회**로 실시간 방위각을 확인합니다
- 나침반 다이얼이 디바이스 방향에 따라 회전합니다
- **정보 저장**으로 현재 나침반 정보를 서버 또는 SQLite에 전송합니다
- **정보 목록**으로 저장된 기록을 확인하고, 항목을 선택해 삭제할 수 있습니다

### 목록·상세
저장된 방위각, 정확도, 시각을 확인할 수 있습니다.

## 주의사항

- 자기 센서가 없는 기기·일부 에뮬레이터에서는 방위각이 오지 않습니다
- iOS 시뮬레이터는 센서 테스트가 제한됩니다
- 서버 저장을 쓰려면 웹서버가 실행 중이어야 합니다
- 목록·등록·삭제는 기기 uuid가 있어야 합니다. 연결 확인도 같은 uuid를 붙입니다

## 기술적 특징

- **실시간 스트림**: `flutter_compass` 이벤트로 다이얼을 갱신
- **웹 경로**: `/cps` (`COMPASS`)
- **연결 모드**: 서버/SQLite (`CompassConnectionResolver`)
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
