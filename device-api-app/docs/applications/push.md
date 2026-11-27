# 푸시 알림 (Push)

## 개요

푸시 기능은 FCM을 **수신 전용**으로 쓰는 샘플입니다. 디바이스를 서버에 등록한 뒤, 서버 웹(`/fcm`)에서 메시지를 발송하면 이 앱이 알림을 받습니다. 등록 정보는 `/pus` REST와 SQLite로 저장·조회·삭제합니다.

## 주요 기능

### 1. FCM 자동 준비
- 앱 실행 시 알림 권한을 확인하고 FCM 등록 토큰을 자동 발급합니다

### 2. 푸시 수신
- 서버 웹(`/fcm`) 또는 업무 시스템에서 발송한 FCM 푸시를 수신합니다

### 3. 디바이스 등록
- FCM 토큰과 디바이스 정보를 `PUSH_DEVICE` 테이블에 저장합니다
- OS 버전, 디바이스 이름, 네트워크 정보, 토큰을 포함합니다

### 4. 수신 메시지 목록
- 서버 `PUSH_MESSAGE`에서 현재 기기 UUID로 수신한 메시지 이력을 조회합니다

### 5. 등록 디바이스 삭제
- 서버/SQLite에 저장된 등록 디바이스 목록을 초기화할 수 있습니다

### 6. SQLite 연동
- MySQL `PUSH_DEVICE`와 동일 스키마로 로컬 CRUD를 지원합니다

## 아키텍처 구조

### Domain Layer
- **Entity**: `PushDeviceInfo`
  - `sn`, `uuid`, `ntwrkDeviceInfo`, `osVer`, `deviceNm`, `useYn`, `osType`, `tokenId`
- **Entity**: `PushMessageInfo`
  - `sn`, `uuid`, `message`, `sndDt`, `tokenId`
- **Repository**: `PushRepository` (인터페이스)
- **UseCase**: `PushUseCase`

### Data Layer
- **Service**: `PushService`, `FirebaseMessagingService`
  - FCM 초기화·토큰·포그라운드 수신
  - 서버 REST(`/pus`) 등록·목록
- **Repository Implementation**: `PushRepositoryImpl`

### Presentation Layer
- **Screen**: `PushPage`
  - 권한·토큰·등록 UI (`PushOverview`, `PushCard`)
  - 수신 목록

## 의존성

- `firebase_core: ^3.15.2`: Firebase 초기화
- `firebase_messaging: ^15.2.10`: FCM 토큰·메시지
- `flutter_local_notifications: ^18.0.1`: 로컬 알림 표시
- `http: ^1.5.0`: 서버 통신

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **푸시 알림**으로 진입합니다.

>**사용 방법**
- 앱 실행 시 알림 권한을 허용하면 FCM 토큰이 자동 발급됩니다
- 하단 **디바이스 등록**으로 FCM 토큰을 서버에 저장합니다
- PC 브라우저에서 서버 `/fcm` 페이지로 접속해 메시지를 작성·발송합니다
- **수신 목록**에서 이 기기로 발송된 메시지 이력을 확인할 수 있습니다

## 주의사항

- 에뮬레이터는 Google Play 이미지와 `google-services.json`이 맞아야 FCM이 동작합니다
- 발송은 앱이 하지 않습니다. 서버 웹 `/fcm`이 발송 화면입니다
- `main.dart`에서 `FirebaseMessagingService.initializeFirebase()`가 선행됩니다
- 서버 등록을 쓰려면 웹서버와 Firebase Admin 설정이 필요합니다
- 디바이스 등록·메시지 목록은 기기 uuid가 있어야 합니다. 연결 확인도 같은 uuid를 붙입니다

## 기술적 특징

- **수신 전용 샘플**: 앱은 토큰 등록과 수신 UI만 담당
- **웹 경로**: `/pus` (`PUSH_DEVICE`), 발송 UI `/fcm`
- **연결 모드**: 서버/SQLite (`PushConnectionResolver`)
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
