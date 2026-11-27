# 연락처 (Contacts)

## 개요

연락처 기능은 `flutter_contacts`로 디바이스 연락처를 조회하고, eGovFrame 웹 서버(`/ctt`) 또는 로컬 SQLite와 연계하여 연락처 정보를 저장·조회·삭제하는 샘플입니다.

## 주요 기능

### 1. 연락처 조회
- 디바이스 연락처 목록을 조회하고 선택할 수 있습니다
- 이름·전화번호·이메일이 미리보기 카드에 표시됩니다

### 2. 연락처 저장
- 선택한 연락처를 `CONTACT_INFO` 테이블에 저장합니다
- 서버로 올리거나, 디바이스 주소록에 다시 쓰는 흐름을 제공합니다

### 3. 연락처 목록
- 서버 MySQL 또는 로컬 SQLite에서 저장된 기록을 조회합니다

### 4. 연락처 삭제
- 저장된 연락처 목록을 초기화(삭제)할 수 있습니다

### 5. SQLite 연동
- MySQL `CONTACT_INFO`와 동일 스키마로 로컬 CRUD를 지원합니다

## 아키텍처 구조

### Domain Layer
- **Entity**: `ContactsInfo`
  - `sn`: 일련번호
  - `name`: 이름
  - `telno`: 전화번호
  - `emails`: 이메일
  - `useYn`: 사용 여부
  - `uuid`: 디바이스 고유 식별자
- **Repository**: `ContactsRepository` (인터페이스)
- **UseCase**: `ContactsUseCase`

### Data Layer
- **Service**: `ContactsService`
  - 기기 주소록 읽기/쓰기
  - 서버 REST(`/ctt`) 전송
- **Repository Implementation**: `ContactsRepositoryImpl`

### Presentation Layer
- **Screen**: `ContactsPage`
  - 연락처 선택·미리보기 (`ContactsOverview`, `ContactsCard`)
  - 저장 및 목록 조회

## 의존성

- `flutter_contacts: ^1.1.9+2`: 디바이스 연락처 접근
- `permission_handler: ^11.2.0`: 연락처 권한
- `http: ^1.5.0`: 서버 통신

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **연락처**로 진입합니다.

>**사용 방법**
- 앱 실행 시 연락처 권한을 허용하면 디바이스 연락처 목록이 표시됩니다
- 목록에서 저장할 연락처를 탭하여 선택합니다
- 선택한 연락처의 이름·전화번호·이메일이 미리보기 카드에 표시됩니다
- **정보 저장**으로 선택한 연락처를 서버 또는 SQLite에 전송합니다
- **정보 목록**으로 저장된 기록을 확인하고, 목록 화면에서 삭제할 수 있습니다

## 주의사항

- 연락처 읽기(및 쓰기를 쓰는 경우 쓰기) 권한이 필요합니다
- 권한을 거부하면 기기 목록을 가져올 수 없습니다
- 서버 저장을 쓰려면 웹서버가 실행 중이어야 합니다
- 목록·등록·삭제는 기기 uuid가 있어야 합니다. 연결 확인도 같은 uuid를 붙입니다

## 기술적 특징

- **기기 주소록**: `flutter_contacts`로 네이티브 연락처 API 호출
- **웹 경로**: `/ctt` (`CONTACT_INFO`)
- **연결 모드**: 서버/SQLite (`ContactsConnectionResolver`)
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
