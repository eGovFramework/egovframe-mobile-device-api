# 의존성 주입 (Dependency Injection)

의존성 주입은 Clean Architecture에서 중요한 역할을 합니다. 객체를 직접 생성하지 않고, 외부에서 주입받는 기법입니다.

## GetIt을 사용한 의존성 주입

본 프로젝트는 GetIt을 사용하여 의존성을 관리합니다.

### 의존성 주입 설정

```dart
// di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

// Repository 구현체
import 'package:egovframe_mobile_deviceapi_app/data/repositories/device_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/repositories/gps_repository_impl.dart';
// ... 기타 Repository 구현체

// Repository 인터페이스
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/device_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/gps_repository.dart';
// ... 기타 Repository 인터페이스

// Use Cases
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/device_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/gps_usecase.dart';
// ... 기타 Use Cases

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // 외부 라이브러리 등록
  getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Repository 구현체 등록
  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<GpsRepository>(
    () => GpsRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<AcceleratorRepository>(
    () => AcceleratorRepositoryImpl(),
  );
  
  // ... 기타 Repository 등록

  // Use Case 등록 (Repository 주입)
  getIt.registerLazySingleton<DeviceUseCase>(
    () => DeviceUseCase(getIt()),  // getIt()으로 Repository 주입
  );
  
  getIt.registerLazySingleton<GpsUseCase>(
    () => GpsUseCase(getIt()),
  );
  
  // ... 기타 Use Case 등록
}
```

### 앱 진입점에서 초기화

```dart
// main.dart
import 'di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setupDependencies(); // 의존성 주입 초기화
  
  runApp(const MyApp());
}
```

---

## 의존성 주입의 장점

### 1. 느슨한 결합

클래스 간 직접적인 의존성을 제거합니다.

```dart
// 의존성 주입
class DeviceUseCase {
  final DeviceRepository repository;
  
  DeviceUseCase(this.repository);  // 외부에서 주입
}
```

### 2. 테스트 용이성

Mock 객체를 쉽게 주입할 수 있습니다.

**테스트 예시**:
```dart
// 테스트에서 Mock 객체 주입
class MockDeviceRepository implements DeviceRepository {
  @override
  Future<DeviceInfo> getDeviceInfo() async {
    return DeviceInfo(/* Mock 데이터 */);
  }
  // ...
}

// Use Case 테스트
void main() {
  test('DeviceUseCase 테스트', () async {
    final mockRepository = MockDeviceRepository();
    final useCase = DeviceUseCase(mockRepository);
    
    final result = await useCase.getDeviceInfo();
    expect(result, isA<DeviceInfo>());
  });
}
```

### 3. 유연성

런타임에 구현체를 교체할 수 있습니다.

**예시**:
```dart
// 개발 환경: Mock Repository 사용
void setupDependencies() {
  if (kDebugMode) {
    getIt.registerLazySingleton<DeviceRepository>(
      () => MockDeviceRepositoryImpl(),
    );
  } else {
    getIt.registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(),
    );
  }
}
```

### 4. 중앙 관리

모든 의존성을 한 곳에서 관리합니다.

**장점**:
- 의존성 관계를 한눈에 파악 가능
- 의존성 변경 시 한 곳만 수정
- 의존성 순환 참조 방지

---

## 실제 사용 예시

### Presentation Layer에서 사용

```dart
// presentation/screens/deviceInfo/deviceInfo_main.dart
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/device_usecase.dart';

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  late final DeviceUseCase _deviceUseCase;

  @override
  void initState() {
    super.initState();
    _deviceUseCase = getIt<DeviceUseCase>();  // 의존성 주입
  }

  Future<void> _getDeviceInfo() async {
    try {
      deviceInfo = await _deviceUseCase.getDeviceInfo();
    } catch (e) {
      // 에러 처리
    }
  }
}
```

### Use Case에서 Repository 주입

```dart
// domain/usecases/device_usecase.dart
class DeviceUseCase {
  final DeviceRepository repository;  // 인터페이스에 의존

  DeviceUseCase(this.repository);  // 생성자 주입

  Future<DeviceInfo> getDeviceInfo() async {
    return await repository.getDeviceInfo();
  }
}
```

**의존성 주입 흐름**:
1. `setupDependencies()`에서 `DeviceRepositoryImpl` 등록
2. `DeviceUseCase` 생성 시 `getIt<DeviceRepository>()`로 구현체 주입
3. Presentation에서 `getIt<DeviceUseCase>()`로 Use Case 주입

---

## GetIt의 주요 메서드

### registerLazySingleton

싱글톤으로 등록하되, 처음 사용될 때 생성됩니다.

```dart
getIt.registerLazySingleton<DeviceRepository>(
  () => DeviceRepositoryImpl(),
);
```

**특징**:
- 앱 전체에서 하나의 인스턴스만 사용
- 처음 사용될 때 생성 (지연 초기화)
- 메모리 효율적

### registerSingleton

즉시 싱글톤으로 등록합니다.

```dart
getIt.registerSingleton<DeviceRepository>(
  DeviceRepositoryImpl(),
);
```

**특징**:
- 앱 시작 시 즉시 생성
- 항상 사용되는 객체에 적합

### registerFactory

매번 새로운 인스턴스를 생성합니다.

```dart
getIt.registerFactory<DeviceRepository>(
  () => DeviceRepositoryImpl(),
);
```

**특징**:
- 호출할 때마다 새로운 인스턴스 생성
- 상태를 공유하지 않는 객체에 적합

---

## 의존성 주입 패턴

### 생성자 주입 (권장)

생성자를 통해 의존성을 주입합니다.

```dart
class DeviceUseCase {
  final DeviceRepository repository;

  DeviceUseCase(this.repository);  // 생성자 주입
}
```

**장점**:
- 필수 의존성을 명확히 표현
- 불변성 보장 (final 필드)
- 테스트 용이
