# Riverpod 화면 상태

의존성 주입은 [5. 의존성 주입](./5_dependency_injection.md), state 개념은 [State 가이드](../presentation/10_state.md), `copyWith` 규칙은 [Entity·State 작성 규칙](./7_entity_conventions.md)을 따른다.  
이 문서는 그 위에 **화면 Notifier에 필드를 추가하는 법**을 AI 채팅의 AI 서버 연결 상태(`aiServerConnected`)로 설명한다.

## 1. 이 프로젝트에서 나뉘는 Provider

| 종류 | 위치 | 수명 | 예 |
|------|------|------|----|
| Service·Repository·UseCase | `di/providers.dart` | `keepAlive: true` | `aiChatUseCaseProvider` |
| 서버/SQLite 연결 모드 | `di/{feature}_connection_provider.dart` | `keepAlive: true` | `aiChatConnectionProvider` |
| 화면 상태 | `presentation/screens/{feature}/view_model/*_controller.dart` | 화면이 watch하는 동안 | `aiChatMainProvider`, `aiChatListProvider` |

화면 Notifier는 UseCase를 직접 만들지 않는다. `ref.read(aiChatUseCaseProvider)`로 이미 조립된 UseCase를 호출한다.

```dart
AiChatUseCase _aiChatUseCase(Ref ref) => ref.read(aiChatUseCaseProvider);
```

## 2. 추가된 상태: `aiServerConnected`

AI 채팅은 device-api-web 연결과 AI 서버(egovframe-ai-rag) 연결을 구분한다.

| 값 | 의미 | 화면 |
|----|------|------|
| `null` | 아직 모르거나, 웹 호출이 실패해 확인하지 못함 | 배너를 그리지 않음. 웹이 죽으면 목록 오류가 이미 그 역할을 함 |
| `true` | 웹이 ai-rag에 닿음 | 배너 없음 |
| `false` | 웹은 응답했고 ai-rag는 끊김 | `AiChatAiServerBanner` |

필드는 두 state에 있다.

- `AiChatMainState.aiServerConnected` — 채팅 화면. `AiChatMain.initialize()`가 채움
- `AiChatListState.aiServerConnected` — 저장 목록. `AiChatList.reload()`가 채움

배너는 `== false`일 때만 보인다. `null`과 `true`는 같은 화면(안내 없음)이다.

```dart
if (aiServerConnected == false) ...[
  const AiChatAiServerBanner(),
  const SizedBox(height: 12),
],
```

채팅 화면은 `ai_chat_main.dart`가 `mainState.aiServerConnected`를 `AiChatOverview`에 넘긴다. 목록 화면은 `ai_chat_list.dart`가 `listState.aiServerConnected`를 직접 본다.

## 3. `copyWith`와 `updateAiServerConnection`

`bool?`은 “인자를 안 넘김”과 “`null`을 넘김”이 코드에서 같다. `aiServerConnected ?? this.aiServerConnected`로 쓰면, 확인 결과가 `null`일 때 예전 값이 남는다.

그래서 이 필드만 플래그로 갱신한다. [Entity 규칙](./7_entity_conventions.md)의 `clearXxx`와 같은 이유이고, `null`이 “비움”이 아니라 “모름”이라는 값이므로 이름은 `updateAiServerConnection`이다.

```dart
AiChatMainState copyWith({
  bool? aiServerConnected,
  bool updateAiServerConnection = false,
}) {
  return AiChatMainState(
    // ...다른 필드는 value ?? this.value
    aiServerConnected: updateAiServerConnection
        ? aiServerConnected
        : this.aiServerConnected,
  );
}
```

질문 초안처럼 보통 필드를 바꿀 때는 플래그를 넘기지 않는다. 그러면 `aiServerConnected`는 유지된다.

## 4. 조회 흐름

`AiChatMain.initialize()`는 UUID와 AI 서버 확인을 같이 시작한다. UUID가 오면 로딩을 끝내고, AI 서버 결과(최대 수 초)는 그 다음에 state에 넣는다. 채팅 화면은 확인이 끝날 때까지 멈추지 않는다.

```dart
Future<void> initialize() async {
  final uuidFuture = _aiChatUseCase(ref).getDeviceUuid();
  final aiServerFuture = _aiChatUseCase(ref).checkAiServerConnection();
  final uuid = await uuidFuture;
  if (!ref.mounted) return;
  state = state.copyWith(isLoading: false, uuid: uuid);

  final aiServerConnected = await aiServerFuture;
  if (!ref.mounted) return;
  state = state.copyWith(
    aiServerConnected: aiServerConnected,
    updateAiServerConnection: true,
  );
}
```

`AiChatList.reload()`도 목록 조회와 AI 서버 확인을 같이 시작하고, 목록 성공·빈 목록·실패 세 갈래 모두 `updateAiServerConnection: true`로 넣는다.

`await` 뒤에 state를 쓰면 `ref.mounted`를 본다. 화면이 사라진 Notifier에 쓰면 예외가 난다.

호출 경로는 이렇다.

```text
AiChatMain / AiChatList
  → AiChatUseCase.checkAiServerConnection()
    → AiChatRepositoryImpl.checkAiServerConnection()
      → AiChatRemoteRepositoryImpl
        → GET /aic/selectAiRagConnection.do
```

이 확인은 `DeviceApiClient.probe`가 아니다. `get`으로 본문 `connected`를 읽는다. 구분은 [DeviceApiClient](./9_device_api_client.md) 4절이다.

SQLite 모드여도 Facade는 `_remote.checkAiServerConnection()`을 호출한다. 로컬 목록을 보더라도 AI 서버 안내는 웹 경유로 판단한다. SQLite 구현의 같은 메서드는 `null`을 반환하지만, Facade가 그 구현을 쓰지 않는다.

## 5. 화면 Notifier를 추가할 때

1. `state/{feature}_state.dart`에 필드와 `initial()`, `copyWith`를 둔다. `bool?`처럼 `null`이 의미 있는 값이면 갱신 플래그를 둔다.
2. `view_model/{feature}_controller.dart`에 `@riverpod class`를 둔다. `build()`는 초기 state를 바로 반환하고, 비동기는 `Future.microtask`로 뺀다.
3. `part '{file}.g.dart';`를 넣고 생성한다.

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. 화면은 `ref.watch(provider)`로 그리고, 버튼 핸들러는 `ref.read(provider.notifier)`로 메서드를 호출한다.
5. `*.g.dart`는 수정하지 않는다.

생성된 이름은 클래스 `AiChatMain` → `aiChatMainProvider`이다.

## 6. 체크리스트

- [ ] 화면이 사라질 수 있는 `await` 뒤에 `ref.mounted`를 봤는가
- [ ] `bool?` / 지워야 하는 nullable을 `?? this`로 덮어쓰지 않았는가
- [ ] 배너·오류 UI가 `null`(모름)과 `false`(끊김)를 구분하는가
- [ ] UseCase 조립을 화면에서 `new`하지 않고 `di/providers.dart` Provider를 읽는가
- [ ] `@riverpod`을 추가한 뒤 `build_runner`로 `*.g.dart`를 다시 만들었는가
