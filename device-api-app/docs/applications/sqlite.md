# SQLite Manager

## 개요

SQLite Manager는 앱 내부 저장소에 SQLite 데이터베이스를 생성하고, 테이블·컬럼·데이터를 관리하는 기능입니다. `.db` / `.sqlite` 파일을 가져와 읽고 수정한 뒤 export할 수 있습니다. 다른 Device API 기능의 로컬 모드와 같은 스키마를 만들 때 사용합니다.

## 주요 기능

### 1. DB 관리
- 내부 DB 생성·삭제·Downloads 저장·가져오기·공유

### 2. 테이블 관리
- `CREATE TABLE`로 테이블 생성, 컬럼·인덱스·외래키 설정

### 3. 스키마 관리
- `PRAGMA table_info`로 컬럼 조회, `ALTER TABLE`로 컬럼 추가

### 4. 데이터 CRUD
- insert / query / update / delete로 행 추가·조회·수정·삭제

### 5. 파일 연동
- `.db`, `.sqlite`, `.sqlite3` 파일을 import하여 읽고 수정한 뒤 export

## 아키텍처 구조

SQLite Manager는 센서/REST feature와 달리 `lib/sqlite` 서비스를 화면에 가깝게 붙입니다.

### Presentation Layer
- **Screen**: `SqliteMainPage`
  - DB 목록·생성·가져오기
  - DB 상세 (`SqliteDatabaseDetailPage`)
  - 테이블 생성 (`SqliteCreateTablePage`)
  - 스키마 (`SqliteTableSchemaPage`)
  - 데이터 (`SqliteTableDataPage`)
- **Controller**: `SqliteController` (Riverpod)

### 패키지
- `lib/sqlite`: `SqliteService`, `FeatureTableService`, 스키마 검증. 다른 기능은 `package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart`로 같은 코드를 쓴다.

다른 기능 앱은 `lib/config/{feature}_sqlite_schema.dart`의 컬럼 정의와 맞춘 테이블을 이 화면에서 만들 수 있습니다.

## 의존성

- `sqflite`, `path`: `lib/sqlite`가 DB 파일과 테이블 API에 사용
- `file_picker: ^8.1.4`: DB 파일 가져오기
- `share_plus: ^10.1.4`: DB 파일 공유
- `path_provider: ^2.1.2`: 내부 저장 경로

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **SQLite**로 진입합니다.

>**사용 방법**
- 메인에서 **DB 생성** 또는 **DB 가져오기**로 내부 DB를 준비합니다
- DB를 탭하면 테이블 목록을 확인할 수 있습니다
- **테이블 생성**으로 컬럼·인덱스·외래키를 설정해 테이블을 만듭니다
- 다른 기능 앱(기기 정보, AI 채팅 등)과 연동할 때는 해당 앱의 스키마와 같은 테이블·컬럼을 만듭니다
- 테이블을 탭하면 데이터를 조회·추가·수정·삭제할 수 있습니다
- 테이블 메뉴에서 스키마 보기, 컬럼 추가(`ALTER TABLE`)가 가능합니다
- DB 메뉴에서 Downloads 저장·공유·삭제를 수행합니다

## 주의사항

- 서버 REST가 없는 로컬 전용 기능입니다
- 다른 기능의 SQLite 모드와 쓰려면 **테이블명·컬럼명이 스키마와 같아야** 합니다 (예: AI 채팅 `AI_CHAT_INFO`)
- 잘못된 파일을 import하면 검증 오류가 납니다 (`sqlite_file_validator.dart`)

## 기술적 특징

- **내부 저장소 + 파일 export**: 앱 샌드박스 DB를 Downloads/공유로 꺼냄
- **기능 연동**: 각 feature `*_sqlite_schema.dart`의 required/optional 컬럼과 맞춤
- **Clean Architecture**: 화면 상태만 Riverpod, 실제 SQL은 `lib/sqlite`
