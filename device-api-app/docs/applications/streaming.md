# 스트리밍 미디어 (Streaming)

## 개요

스트리밍 기능은 서버에 등록된 멀티미디어(동영상)를 조회하고 네트워크로 재생하는 샘플입니다. `/stm/mediaInfoList.do`, `/stm/getMediaStreaming.do`, `/stm/updateMediaInfoRevivCo.do` API를 사용합니다.

## 주요 기능

### 1. 멀티미디어 목록 조회
- 서버 `MEDIA` 테이블에서 제목, 파일 타입, 재생횟수를 조회합니다

### 2. 멀티미디어 재생
- 목록 항목을 선택하면 확인 후 `video_player`로 네트워크 스트리밍 동영상을 재생합니다

### 3. 재생횟수 업데이트
- 재생이 시작되면 서버에 재생횟수(`REVIV_CO`)를 자동으로 증가시킵니다

### 4. SQLite 연동
- 서버와 동일한 형태의 로컬 목록 CRUD를 지원합니다 (재생 자체는 네트워크 스트림)

## 아키텍처 구조

### Domain Layer
- **Entity**: `StreamingMediaInfo`
  - `sn`: 미디어 일련번호
  - `fileSn`: 파일 일련번호
  - `mdSj`: 제목
  - `mdCode`: 파일 타입 코드
  - `revivCo`: 재생횟수
- **Repository**: `StreamingRepository` (인터페이스)
- **UseCase**: `StreamingUseCase`

### Data Layer
- **Service**: 스트리밍 REST 클라이언트
  - 목록 조회
  - 스트리밍 URL 구성
  - 재생횟수 갱신
- **Repository Implementation**: `StreamingRepositoryImpl`

### Presentation Layer
- **Screen**: `StreamingPage`
  - 미디어 목록
  - 내장 플레이어 (`StreamingVideoPlayerPage`)

## 의존성

- `video_player: ^2.10.0`: 네트워크 동영상 재생
- `http: ^1.5.0`: 서버 통신

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **스트리밍 미디어**로 진입합니다. 멀티미디어 재생 DeviceAPI로 실시간 동영상을 볼 수 있습니다.

>**사용 방법**
- **미디어 목록 보기**로 서버에 등록된 멀티미디어 목록을 조회합니다
- 목록에서 항목을 탭하고 '동영상을 재생하시겠습니까?'를 확인한 뒤 재생합니다
- 재생이 시작되면 재생횟수가 서버에 업데이트되고, 내장 플레이어에서 스트리밍됩니다

### 재생 화면
네트워크 URL을 `video_player`로 재생합니다. `fileSn`이 있으면 `/mda/downloadMediaFile.do`에 `fileSn`과 기기 `uuid`를 붙이고, 없으면 `/stm/getMediaStreaming.do`에 `sn`과 `uuid`를 붙입니다.

## 주의사항

- 서버에 미디어가 등록되어 있고 파일 스토어 경로가 맞아야 합니다
- 재생 목록 `mediaInfoList.do`는 기기 uuid를 붙여 이 기기의 `MEDIA` 행을 조회합니다. 연결 확인은 같은 주소에 uuid 없이 호출하며, 응답이 200이면 연결된 것으로 봅니다
- `selectStreamingMediaInfoList`·등록·삭제는 기기 uuid가 있어야 합니다
- 재생은 HTTP 스트리밍이므로 웹서버와 네트워크가 필요합니다
- 실기기에서는 `AppConfig.baseUrl`이 LAN IP여야 재생 URL이 열립니다

## 기술적 특징

- **웹 경로**: `/stm` (`MEDIA`)
- **재생횟수**: 재생 시작 시 `updateMediaInfoRevivCo.do`
- **연결 모드**: 서버/SQLite (`StreamingConnectionResolver`)
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
