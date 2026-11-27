# 서버와 SQLite 전환

저장이 있는 기능은 서버(device-api-web)와 앱 안 SQLite 중 하나를 고른다.  
파일 관리와 SQLite Manager는 서버가 없으므로 이 구성을 두지 않는다.

정본으로 볼 코드는 바코드다. `di/barcode_connection_provider.dart`, `presentation/screens/barcode/widgets/barcode_connection_resolver.dart`, `view_model/barcode_connection_status_controller.dart`.

## 1. 세 조각

| 조각 | 파일 | 하는 일 |
|------|------|---------|
| 연결 모드 | `di/{feature}_connection_provider.dart` | `keepAlive` Notifier. `useServer()` / `useSqlite(파일명)` |
| 상태 카드 | `*_connection_status_controller.dart` + 카드 위젯 | 화면을 열 때 서버 도달과 SQLite 준비 여부를 표시 |
| Resolver | `*_connection_resolver.dart` | 목록·저장 버튼이 화면을 열기 전에 현재 모드를 확인 |

`BarcodeRepositoryImpl`은 `readConnection().isSqlite`로 원격 구현과 SQLite 구현 중 하나를 고른다. 화면은 Service를 직접 호출하지 않고 UseCase만 호출한다.

SQLite를 켜려면 해당 기능 테이블이 있는 `.db`가 있어야 한다. 없으면 Resolver가 가져오기 안내를 띄운다. 스키마는 `config/{feature}_sqlite_schema.dart`의 `requiredColumns`로 검사한다. DB API는 `lib/sqlite/sqlite.dart`에 있다.

## 2. 화면을 열 때와 목록을 열 때

바코드 기준으로 호출은 이렇게 나뉜다.

1. 기능 화면이 열리면 연결 상태 카드가 `isServerConnected()`를 호출한다. 안에서는 목록 URL `probe`이고, 응답 목록은 버린다.
2. 정보 목록 버튼을 누르면 `BarcodeConnectionResolver.resolveConnection`이 한 번 더 `probe`한다. SQLite 모드면 서버 대신 DB 파일과 테이블을 검사한다.
3. 목록 화면의 `BarcodeList.build()`가 `reload()`로 같은 목록 URL을 다시 조회하고, 이때 받은 행을 그린다.

1번과 2번은 연결 여부만 필요하고, 3번은 화면에 그릴 데이터가 필요하다. 목록 버튼을 누르는 순간 2번과 3번이 연속으로 나가서 같은 SELECT가 두 번 실행된다. 상태 카드가 받아 둔 목록을 나중에 재사용하지 않는다. 그 사이 저장·삭제가 있으면 화면과 서버가 어긋나기 때문이다.

연결 확인이 200을 보려면 목록 API 계약을 지켜야 한다. 바코드·얼굴 메시·AI 채팅·연락처·나침반·푸시·소켓·IoT는 기기 uuid가 없으면 400이라, `probe`에도 uuid를 붙인다. [기기 UUID](./10_device_uuid.md), [DeviceApiClient](./9_device_api_client.md).

## 3. AI 채팅만 다른 점

대화 저장·목록은 다른 기능과 같이 서버 또는 SQLite를 따른다. 질의는 SQLite 모드여도 device-api-web이 필요하다.

AI 서버(egovframe-ai-rag) 확인은 연결 모드와 별개다. Facade가 항상 원격 `checkAiServerConnection()`을 호출한다. 웹은 떠 있고 ai-rag만 끊기면 `aiServerConnected == false`이고, 채팅 화면과 저장 목록에 `AiChatAiServerBanner`가 나온다. 절차는 [Riverpod 화면 상태](./8_riverpod.md)다.

## 4. 기능을 추가할 때

1. `ConnectionMode`(`server` / `sqlite`)와 `ConnectionState`를 domain에 둔다.
2. `di/{feature}_connection_provider.dart`에 Notifier와 SQLite 서비스 Provider를 둔다.
3. Repository Facade가 `readConnection()`으로 원격·SQLite를 고르게 한다.
4. 상태 카드는 화면 진입 시 서버 도달만 보여주고, 목록 데이터는 목록 화면이 다시 읽게 둔다.
5. 목록·저장 버튼은 `ServerConnectionButton`의 `resolveConnection`에 Resolver를 넘긴다.
6. 로컬 전용 기능이면 connection 카드와 Resolver를 만들지 않는다.
