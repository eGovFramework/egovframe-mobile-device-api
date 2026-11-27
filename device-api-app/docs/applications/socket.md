# 소켓 IO (Socket)

## 개요

소켓 기능은 `web_socket_client`로 eGovFrame 웹 서버의 WebSocket 엔드포인트(`/websocket/chat.ws`)에 연결하여 실시간 채팅을 하고, HTTP REST(`/ws`) 또는 SQLite로 메시지를 저장·조회·삭제하는 샘플입니다. 브라우저 `chat-sockjs` 페이지와 `msg:발신자:내용` 형식으로 서로 채팅합니다.

## 주요 기능

### 1. WebSocket 채팅
- `ws://서버/websocket/chat.ws`에 연결합니다
- 웹 페이지와 앱이 같은 프로토콜로 실시간 메시지를 주고받습니다
- 앱 입력은 500자까지이고, 입력칸 아래에 `현재글자/500`이 표시됩니다
- 서버는 `msg:발신자:내용`만 중계합니다. 발신자는 100자, 내용은 1000자입니다. `SOCKET_MESSAGE.SENDER`는 `VARCHAR(100)`, `MESSAGE`는 `VARCHAR(1000)`입니다
- 바이너리 프레임은 중계하지 않습니다
- 동시 접속은 `app.websocket.max-sessions`(기본 50)까지입니다. 넘치면 새 연결이 닫힙니다

### 2. 메시지 저장
- 아직 저장되지 않은 채팅을 `SOCKET_MESSAGE` 테이블에 일괄 저장합니다
- SN은 UUID별 순번이며, 이미 저장된 메시지(`savedSn`)는 건너뜁니다

### 3. 메시지 목록
- 서버 MySQL 또는 로컬 SQLite에서 기록을 조회합니다

### 4. 메시지 삭제
- 저장된 채팅 메시지를 전체 초기화할 수 있습니다

### 5. SQLite 연동
- MySQL `SOCKET_MESSAGE`와 동일 스키마로 로컬 CRUD를 지원합니다

## 아키텍처 구조

### Domain Layer
- **Entity**: `SocketMessageInfo`
  - `sn`: 일련번호
  - `uuid`: 디바이스 고유 식별자
  - `message`: 메시지 본문
  - `sender`: 발신자 닉네임
  - `timestamp`: 시각
  - `useYn`: 사용 여부
- **Repository**: `SocketRepository` (인터페이스)
- **UseCase**: `SocketUseCase`

### Data Layer
- **Service**: `SocketService`
  - WebSocket 연결·송수신
  - 서버 REST(`/ws`) 저장
- **Repository Implementation**: `SocketRepositoryImpl`

### Presentation Layer
- **Screen**: `SocketPage`
  - 닉네임·연결 (`Socket` 메인)
  - 채팅 UI (`SocketChatOverview`)
  - 저장 및 목록 조회

## 의존성

- `web_socket_client: ^0.1.0`: WebSocket 클라이언트
- `http: ^1.5.0`: 메시지 REST 저장

## 화면 구성 및 사용 방법

### 메인 화면

앱 목록에서 **소켓 IO**로 진입합니다.

>**사용 방법**
- 웹 브라우저에서 `http://서버IP:9700/chat-sockjs`를 열고 닉네임을 입력한 뒤 Connect 합니다
- 앱 '주요기능'에서 닉네임을 입력하고 **WebSocket 연결**을 누르면 같은 서버에 연결되며 채팅 화면으로 이동합니다
- 연결 후에는 메인에서 **연결 종료**로 끊거나 **채팅**으로 다시 들어갈 수 있습니다
- 채팅 화면에서 메시지를 입력·전송하면 웹·앱 간 실시간 채팅이 됩니다 (형식: `msg:발신자:내용`, 앱 입력 최대 500자)
- 웹 `/chat-sockjs`의 메시지 입력도 500자, 닉네임은 40자입니다
- **메시지 저장**으로 아직 저장되지 않은 대화를 서버 또는 SQLite에 일괄 저장합니다
- **메시지 목록**으로 저장된 기록을 확인하고, 목록에서 전체 삭제할 수 있습니다

## 주의사항

- WebSocket URL은 `AppConfig.websocketUrl` (`ws://호스트:9700/websocket/chat.ws`)입니다
- 웹 채팅 페이지와 앱이 **같은 서버**를 봐야 메시지가 만납니다
- `localhost`는 실기기에서 동작하지 않으므로 PC LAN IP를 씁니다
- 서버 저장을 쓰려면 HTTP `/ws`와 WebSocket이 모두 떠 있어야 합니다
- 이력 목록·등록·삭제는 기기 uuid가 있어야 합니다. 연결 확인도 같은 uuid를 붙입니다
- 이력 저장 `POST /ws/insertSocketMessageInfo.do`도 발신자 100자, 본문 1000자를 넘으면 거절합니다
- 브라우저 채팅은 서버의 `app.websocket.allowed-origins`에 있는 출처에서만 연결됩니다. 공통 값은 `http://localhost:9700`, `http://127.0.0.1:9700`입니다

## 기술적 특징

- **실시간 채널**: WebSocket, REST는 이력 저장용으로 분리
- **메시지 포맷**: `msg:발신자:내용` (`socket_chat_message_format.dart`). 글자 수는 유니코드 코드 포인트 기준입니다
- **웹 경로**: WS `/websocket/chat.ws`, REST `/ws` (`SOCKET_MESSAGE`)
- **연결 모드**: 서버/SQLite (`SocketConnectionResolver`)
- **Clean Architecture**: 도메인, 데이터, 프레젠테이션 레이어 분리
