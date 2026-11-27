# DeviceApiClient

`lib/core/device_api_client.dart`는 device-api-web REST를 호출하는 공통 HTTP 클라이언트다.  
서버 주소, `Accept`, 폼 인코딩, 제한 시간, JSON과 `resultState` 해석을 여기서 처리한다. 기능 앱은 경로, 파라미터, 목록을 꺼낼 키만 넘긴다.

Interface 기능 앱(`/itf`, 가입·로그인 화면)과는 다른 클래스다. Cordova 가이드의 `EgovInterface.get` / `post` / `geturl`에 해당하는 자리다.

## 1. 주소와 메서드

기본 주소는 `AppConfig.currentBaseUrl`이다. `getUrl()`이 그 값을 반환한다.

| 메서드 | 하는 일 |
|--------|---------|
| `resolve(path, params)` | `/gps/insertGPSInfo.do` 앞에 기본 주소를 붙인다. `params`가 있으면 쿼리로 넣는다. `http`로 시작하면 그대로 쓴다 |
| `get` / `post` / `delete` | 본문을 한 번에 받는 요청. 기본 제한 시간은 `AppConfig.defaultTimeout`(10초) |
| `send` | SSE·multipart처럼 스트림이 필요할 때. `openClient()`로 만든 클라이언트를 넘기고, 스트림을 읽은 뒤 close 한다 |
| `probe` | 연결 확인 전용. 제한 시간은 5초 |

`post`/`delete`의 body가 `Map`이고 `Content-Type`을 따로 주지 않으면 `application/x-www-form-urlencoded`를 붙인다. `Accept`는 `application/json`이다. AI 채팅 SSE는 `send`로 보내고 `Accept`를 `text/event-stream`으로 덮어쓴다. 그 요청의 제한 시간은 10분이다.

## 2. `DeviceApiResult`

`get`/`post`/`delete`의 반환이다. HTTP 상태, 원문 바이트, JSON을 같이 담는다.

| 멤버 | 의미 |
|------|------|
| `statusCode` / `httpOk` | HTTP 상태. `httpOk`는 200 |
| `json` | 객체 JSON. 파싱 실패나 배열이면 `null` |
| `resultState` / `resultMessage` | 본문의 같은 이름 필드 |
| `isSuccess` | HTTP 200이고, `resultState`가 없거나 `OK`·`PARTIAL` |
| `list(key)` | `json[key]`가 배열이면 `Map` 목록. 아니면 빈 목록 |

목록 조회는 `list('barcodeInfoList')`처럼 기능마다 키 이름이 다르다. 화면은 `isSuccess`와 이 목록으로 성공·빈 목록·실패를 가른다.

## 3. `probe`는 상태 코드만 본다

연결 확인은 각 기능의 `*_server_connection_service.dart`가 `probe`를 호출한다. 응답 본문과 `resultState`는 읽지 않는다.

| HTTP | `ServerConnectionResult` |
|------|--------------------------|
| 200 | `connected` |
| 500 | `serverDbError` (MySQL `hyb` 확인) |
| 그 외 상태, 타임아웃, 예외 | `serverUnreachable` |
| 기기 네트워크 없음 (`checkNetwork: true`일 때) | `networkUnavailable` |

호출하는 URL은 기능의 목록·조회 API다. 200이면 연결됨으로 보고, 응답에 들어 있는 목록은 버린다. 목록 화면은 열릴 때 같은 URL을 다시 조회한다. 목록 버튼을 누를 때는 직전 확인과 화면 조회가 연속으로 두 번 나간다. 이 샘플의 목록은 한 기기 분량이라 비용은 왕복 한 번이다.

```dart
final uuid = await DeviceUuidUtil.getDeviceUuid();
return DeviceApiClient.probe(
  url: Uri.parse(AppConfig.getBarcodeUrl('/selectBarcodeInfoList.do'))
      .replace(queryParameters: {'uuid': uuid}),
  featureName: 'Barcode',
);
```

uuid는 연결 확인 자체의 필수 값이 아니다. 목록 API가 uuid 없이 400을 돌려주면, `probe`는 그 400을 연결 실패로 처리하기 때문에 쿼리에 붙인다.

| 연결 확인 | uuid |
|-----------|------|
| 바코드 `GET /bar/selectBarcodeInfoList.do` | 기기 uuid |
| 얼굴 메시 `GET /fms/selectFaceMeshInfoList.do` | 기기 uuid |
| AI 채팅 `GET /aic/selectAiChatInfoList.do` | 기기 uuid. device-api-web이 떠 있는지만 본다 |
| 연락처, 나침반, 푸시, 소켓, IoT 목록 | 기기 uuid. 없으면 400 |
| 가속기, GPS, 기기 정보, 파일 오프너, 미디어, 스트리밍 `POST /stm/mediaInfoList.do` | 없음 |

인터페이스는 `POST /itf/selectInterfaceInfo.do`에 빈 `userId`·`userPw`를 보낸다. 스트리밍은 `checkNetwork: false`로 기기 네트워크 사전 확인을 건너뛴다.

## 4. AI 서버 확인은 `probe`가 아니다

device-api-web과 egovframe-ai-rag는 따로 본다.

| 확인 | 호출 | 판단 |
|------|------|------|
| device-api-web | `probe` → 목록 API + 기기 uuid | HTTP 200이면 연결됨. 본문은 버림 |
| ai-rag | `AiChatService.fetchAiRagConnection` → `GET /aic/selectAiRagConnection.do` | 이 응답은 항상 200을 노린다. 본문 `connected`가 `true`/`false`다. 웹에 닿지 못하면 `null` |

`fetchAiRagConnection`은 `DeviceApiClient.get`을 쓰고 `json['connected']`를 읽는다. `probe`에 넣으면 `connected: false`여도 HTTP 200이라 연결됨이 된다. 화면 배너 조건은 [Riverpod 화면 상태](./8_riverpod.md)의 `aiServerConnected == false`다.

## 5. 기능 서비스를 넣을 때

1. URL은 `AppConfig.getXxxUrl('/select….do')`로 만든다.
2. 등록·수정·삭제는 `post`/`delete`와 `isSuccess`로 판단한다.
3. 목록은 `get`과 `list('응답키')`로 꺼낸다.
4. 연결 확인이 그 목록 URL을 쓰면, 그 API가 400을 돌려주는 파라미터를 `probe`에도 붙인다. 기기 uuid의 저장 위치는 [기기 UUID](./10_device_uuid.md), 상태 카드와 목록 화면이 나눠 호출하는 순서는 [서버와 SQLite 전환](./11_server_sqlite_connection.md)이다.
5. 본문의 참·거짓으로 연결을 나눠야 하면 `probe` 대신 `get`으로 필드를 읽는다.
