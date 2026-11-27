# 의존성 주입 (Dependency Injection)

의존성 주입은 Clean Architecture에서 중요한 역할을 합니다. 객체를 직접 생성하지 않고, 외부에서 주입받는 기법입니다.

## Riverpod을 사용한 의존성 주입

본 프로젝트는 **GetIt이 아니라 Riverpod** 으로 의존성을 관리합니다.

- `di/providers.dart` — Service·Repository·UseCase (`@Riverpod(keepAlive: true)`)
- `di/{feature}_connection_provider.dart` — 서버/SQLite 연결 모드
- 화면 상태는 `presentation/screens/{feature}/view_model/*_controller.dart` 의 `@riverpod class`
- `build_runner` 가 `*.g.dart` 를 생성합니다 (`part '...g.dart'`)

### 의존성 주입 설정

```dart
// di/providers.dart (발췌)
@Riverpod(keepAlive: true)
DeviceRepository deviceRepository(Ref ref) {
  DeviceConnectionState readConnection() => ref.read(deviceConnectionProvider);
  return DeviceRepositoryImpl(
    remote: DeviceRemoteRepositoryImpl(),
    sqlite: DeviceSqliteRepositoryImpl(
      ref.watch(deviceSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
DeviceUseCase deviceUseCase(Ref ref) =>
    DeviceUseCase(ref.watch(deviceRepositoryProvider));

@Riverpod(keepAlive: true)
AiChatRepository aiChatRepository(Ref ref) {
  AiChatConnectionState readConnection() => ref.read(aiChatConnectionProvider);
  return AiChatRepositoryImpl(
    remote: AiChatRemoteRepositoryImpl(),
    sqlite: AiChatSqliteRepositoryImpl(
      ref.watch(aiChatSqliteServiceProvider),
      readConnection,
    ),
    readConnection: readConnection,
  );
}

@Riverpod(keepAlive: true)
AiChatUseCase aiChatUseCase(Ref ref) =>
    AiChatUseCase(ref.watch(aiChatRepositoryProvider));
```

연결 모드는 feature별 Notifier입니다.

```dart
// di/ai_chat_connection_provider.dart
@Riverpod(keepAlive: true)
class AiChatConnection extends _$AiChatConnection {
  @override
  AiChatConnectionState build() => const AiChatConnectionState();

  void useServer() { /* ... */ }
  void useSqlite(String dbFileName) { /* ... */ }
}
```

### 앱 진입점에서 초기화

GetIt `setupDependencies()` 호출은 없습니다. `main.dart` 에서 `ProviderScope` 만 감쌉니다.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMessagingService.initializeFirebase();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}
```

코드 생성:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 의존성 주입의 장점

### 1. 느슨한 결합

클래스 간 직접적인 의존성을 제거합니다.

```dart
class DeviceUseCase {
  final DeviceRepository repository;

  DeviceUseCase(this.repository);  // 외부에서 주입
}
```

### 2. 테스트 용이성

UseCase는 생성자로 Repository를 받으므로 Mock을 바로 넣을 수 있습니다.

```dart
class MockDeviceRepository implements DeviceRepository {
  @override
  Future<DeviceInfo> getDeviceInfo() async {
    return DeviceInfo(/* Mock 데이터 */);
  }
}

void main() {
  test('DeviceUseCase 테스트', () async {
    final useCase = DeviceUseCase(MockDeviceRepository());
    final result = await useCase.getDeviceInfo();
    expect(result, isA<DeviceInfo>());
  });
}
```

위젯/Provider 테스트에서는 `ProviderScope(overrides: [...])` 로 구현체를 바꿉니다.

### 3. 유연성

연결 모드 Provider가 서버/SQLite 구현을 고릅니다. Domain UseCase 코드는 바뀌지 않습니다.

### 4. 중앙 관리

- 전역 그래프: `di/providers.dart`
- 연결 모드: `di/{feature}_connection_provider.dart`
- 화면 상태: feature `view_model`

---

## 실제 사용 예시

### Presentation Layer에서 사용

화면은 `ConsumerStatefulWidget` / `ConsumerWidget` 이고, UseCase는 Provider에서 읽습니다.

```dart
// presentation/screens/aiChat/view_model/ai_chat_controller.dart
AiChatUseCase _aiChatUseCase(Ref ref) => ref.read(aiChatUseCaseProvider);

@riverpod
class AiChatMain extends _$AiChatMain {
  Future<AiChatAskResult> askCurrentQuestion() async {
    return _aiChatUseCase(ref).askQuestion(info, onToken: (token) { /* ... */ });
  }
}
```

Device Info도 같은 패턴입니다. `getIt<DeviceUseCase>()` 는 쓰지 않습니다.

```dart
final useCase = ref.read(deviceUseCaseProvider);
```

### Use Case에서 Repository 주입

```dart
class AiChatUseCase {
  final AiChatRepository repository;

  AiChatUseCase(this.repository);

  Future<AiChatAskResult> askQuestion(AiChatInfo info, {void Function(String token)? onToken}) {
    return /* repository.askAiChat ... */;
  }
}
```

**의존성 주입 흐름**:
1. `ProviderScope` 가 앱을 감쌈
2. `aiChatRepositoryProvider` 가 원격/SQLite 구현을 조립
3. `aiChatUseCaseProvider` 가 Repository를 UseCase에 주입
4. 화면 Notifier가 `ref.read(aiChatUseCaseProvider)` 로 호출

---

## Riverpod 코드 생성

`@Riverpod` / `@riverpod` 애노테이션은 `*.g.dart` 를 만듭니다. 손수 `Provider` 클래스를 쓰지 않습니다.

| 용도 | 예시 |
|------|------|
| 함수 Provider (UseCase) | `@Riverpod(keepAlive: true) AiChatUseCase aiChatUseCase(Ref ref)` |
| Notifier (연결 모드·화면 상태) | `@riverpod class AiChatMain extends _$AiChatMain` |

---

## 의존성 주입 패턴

### 생성자 주입 (권장)

```dart
class DeviceUseCase {
  final DeviceRepository repository;

  DeviceUseCase(this.repository);
}
```

**장점**:
- 필수 의존성을 명확히 표현
- 불변성 보장 (`final` 필드)
- 테스트 용이

화면 Notifier에 필드를 추가하는 절차와 AI 서버 연결 상태(`aiServerConnected`)는 [Riverpod 화면 상태](./8_riverpod.md)를 본다.
