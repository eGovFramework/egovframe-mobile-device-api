# 실제 코드 예시

Device Info 기능을 예시로 Clean Architecture의 각 레이어가 어떻게 구현되는지 가이드

## 예시: Device Info 기능

### 1. Entity (Domain Layer)

```dart
// domain/entities/device_info.dart
class DeviceInfo {
  final int sn;
  final String uuid;
  final String os;
  final String ntwrkDeviceInfo;
  final String pgVer;
  final String deviceNm;
  final String useYn;
  final String? telno;       // 연락처 개수 (서버 키: TELNO)
  final String? strgeInfo;   // 스토리지 용량 (서버 키: STRGE_INFO)

  DeviceInfo({
    required this.sn,
    required this.uuid,
    required this.os,
    required this.ntwrkDeviceInfo,
    required this.pgVer,
    required this.deviceNm,
    required this.useYn,
    this.telno,
    this.strgeInfo,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      sn: json['sn'] ?? 0,
      uuid: json['uuid'] ?? '',
      os: json['os'] ?? 'Unknown',
      ntwrkDeviceInfo: json['ntwrkDeviceInfo'] ?? 'Unknown',
      pgVer: json['pgVer'] ?? 'Unknown',
      deviceNm: json['deviceNm'] ?? 'Unknown',
      // 서버에서 useYn (대문자 Y) 또는 useyn (소문자 y)로 올 수 있음
      useYn: json['useYn']?.toString() ?? json['useyn']?.toString() ?? 'N',
      telno: json['telno'] ?? json['TELNO'],
      strgeInfo: json['strgeInfo'] ?? json['STRGE_INFO'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sn': sn,
      'uuid': uuid,
      'os': os,
      'ntwrkDeviceInfo': ntwrkDeviceInfo,
      'pgVer': pgVer,
      'deviceNm': deviceNm,
      'useYn': useYn,
      'telno': telno,
      'strgeInfo': strgeInfo,
    };
  }
}
```

**특징**:
- 순수 Dart 클래스 (외부 라이브러리 의존 없음)
- 비즈니스 데이터 구조 정의
- JSON 직렬화/역직렬화 메서드 포함

---

### 2. Repository Interface (Domain Layer)

```dart
// domain/repositories/device_repository.dart
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';

abstract class DeviceRepository {
  Future<DeviceInfo> getDeviceInfo();
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo);
  Future<List<DeviceInfo>> getDeviceList(String uuid);
}
```

**특징**:
- 인터페이스로 정의 (구현 세부사항 없음)
- Domain 레이어에 속함
- 비즈니스 요구사항을 메서드로 표현

---

### 3. Use Case (Domain Layer)

```dart
// domain/usecases/device_usecase.dart
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/device_repository.dart';

class DeviceUseCase {
  final DeviceRepository repository;

  DeviceUseCase(this.repository);

  /// 디바이스 정보 조회
  Future<DeviceInfo> getDeviceInfo() async {
    return await repository.getDeviceInfo();
  }

  /// 디바이스 목록 조회
  Future<List<DeviceInfo>> getDeviceList(String uuid) async {
    return await repository.getDeviceList(uuid);
  }

  /// 디바이스 정보 업로드
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo) async {
    return await repository.uploadDeviceInfo(deviceInfo);
  }
}
```

**특징**:
- 비즈니스 로직 캡슐화
- Repository 인터페이스에 의존
- 하나의 Use Case = 하나의 비즈니스 작업

---

### 4. Repository Implementation (Data Layer)

```dart
// data/repositories/device_repository_impl.dart
import 'package:egovframe_mobile_deviceapi_app/data/datasources/device_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    print('=== DeviceInfo 조회 (DeviceService) ===');
    final info = await DeviceService.getDeviceInfo();
    print('DeviceInfo: $info');
    return info;
  }

  @override
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo) async {
    return await DeviceService.uploadDeviceInfo(deviceInfo);
  }

  @override
  Future<List<DeviceInfo>> getDeviceList(String uuid) async {
    final list = await DeviceService.fetchDeviceInfoList(uuid);
    return list;
  }
}
```

**특징**:
- Domain 레이어의 인터페이스 구현
- Data Source (Service) 호출
- 데이터 변환 담당
- 에러 처리 및 로깅 가능

---

### 5. Data Source (Data Layer)

```dart
// data/datasources/device_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceService {
  /// 로컬 디바이스 정보를 수집해 Domain 엔티티로 반환
  static Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final uuid = await getPersistentUuid();
    final connectionType = await getConnectionType();
    final pgVer = 'Dart ${Platform.version.split(' ').first}';

    // 플랫폼별 디바이스 정보 수집
    String os = Platform.isAndroid ? 'Android' : 'iOS';
    String deviceNm = Platform.isAndroid ? 'Android Device' : 'iOS Device';

    if (Platform.isAndroid) {
      final info = await deviceInfoPlugin.androidInfo;
      os = 'Android ${info.version.release}';
      deviceNm = '${info.brand} ${info.model}';
    } else if (Platform.isIOS) {
      final info = await deviceInfoPlugin.iosInfo;
      os = 'iOS ${info.systemVersion}';
      deviceNm = info.name ?? 'iOS Device';
    }

    return DeviceInfo(
      sn: 0,
      uuid: uuid,
      os: os,
      ntwrkDeviceInfo: connectionType,
      pgVer: pgVer,
      deviceNm: deviceNm,
      useYn: 'Y',
      telno: telno,
      strgeInfo: strgeInfo,
    );
  }

  /// 서버: Device 등록
  static Future<bool> uploadDeviceInfo(DeviceInfo info) async {
    final uri = Uri.parse(AppConfig.getDeviceUrl('/insertDeviceInfo.do'));
    final fields = {
      'uuid': info.uuid,
      'os': info.os,
      'ntwrkDeviceInfo': info.ntwrkDeviceInfo,
      'pgVer': info.pgVer,
      'deviceNm': info.deviceNm,
      'telno': info.telno ?? '',
      'strgeInfo': info.strgeInfo ?? '',
    };

    try {
      final resp = await http.post(uri, body: fields)
          .timeout(AppConfig.defaultTimeout);

      if (resp.statusCode == 200) {
        final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
        final resultState = (jsonMap['resultState'] ?? '').toString();
        return resultState == 'OK';
      }
    } catch (e) {
      print('업로드 오류: $e');
    }
    return false;
  }

  /// 서버: Device 목록 조회
  static Future<List<DeviceInfo>> fetchDeviceInfoList(String uuid) async {
    final uri = Uri.parse(AppConfig.getDeviceUrl('/selectDeviceInfoList.do'))
        .replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await http.get(uri, headers: {'Accept': 'application/json'})
          .timeout(AppConfig.defaultTimeout);

      if (resp.statusCode == 200) {
        final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
        final list = (jsonMap['deviceInfoList'] as List<dynamic>? ?? []);
        return list.map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
```

**특징**:
- 외부 라이브러리 사용 (device_info_plus, http 등)
- 실제 데이터 소스 접근
- 플랫폼별 구현 가능
- 네트워크 에러 처리

---

### 6. Presentation (Presentation Layer)

```dart
// presentation/screens/deviceInfo/deviceInfo_main.dart
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/device_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';

class _DeviceInfoPageState extends State<DeviceInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DeviceInfo? deviceInfo;
  bool isLoading = true;

  late final DeviceUseCase _deviceUseCase;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    // Use Cases 초기화 (의존성 주입)
    _deviceUseCase = getIt<DeviceUseCase>();

    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    setState(() => isLoading = true);
    try {
      deviceInfo = await _deviceUseCase.getDeviceInfo();
    } catch (e, stackTrace) {
      ErrorHandler.logError(e, null, context: 'DeviceInfoPage._getDeviceInfo');
      final errorType = ErrorHandler.detectErrorType(e);
      final errorMessage = ErrorHandler.getErrorMessage(e, errorType);
      await ErrorHandler.showErrorDialog(
        context,
        errorMessage,
        title: '디바이스 정보 조회 실패',
        onRetry: _getDeviceInfo,
        retryText: '다시 시도',
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('기기 정보')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : deviceInfo != null
              ? _buildDeviceInfoView()
              : Center(child: Text('정보를 불러올 수 없습니다.')),
    );
  }
}
```

**특징**:
- Use Case를 통해서만 비즈니스 로직 접근
- UI 상태 관리
- 에러 처리 및 사용자 피드백

---

## 전체 흐름 요약

```
1. Presentation (deviceInfo_main.dart)
   ↓ Use Case 호출
2. Domain Use Case (device_usecase.dart)
   ↓ Repository 인터페이스 사용
3. Data Repository Impl (device_repository_impl.dart)
   ↓ Data Source 호출
4. Data Source (device_service.dart)
   ↓ 실제 데이터 소스 접근
5. 실제 데이터 소스 (API, 로컬 파일 등)
```

**핵심**:
- 각 레이어는 명확한 책임을 가짐
- 레이어 간 의존성 방향이 명확함
- 인터페이스를 통한 느슨한 결합

---

## 다른 모듈 예시

### GPS 모듈

GPS 모듈도 동일한 구조를 따릅니다:

```
domain/
├── entities/gps_info.dart
├── repositories/gps_repository.dart
└── usecases/gps_usecase.dart

data/
├── datasources/gps_service.dart
└── repositories/gps_repository_impl.dart

presentation/
└── screens/gps/gps_main.dart
```

### Accelerator 모듈

```
domain/
├── entities/accelerator_info.dart
├── repositories/accelerator_repository.dart
└── usecases/accelerator_usecase.dart

data/
├── datasources/accelerometer_service.dart
└── repositories/accelerator_repository_impl.dart

presentation/
└── screens/accelerator/accelerator_main.dart
```

모든 모듈이 동일한 아키텍처 패턴을 따르므로, 코드 일관성과 유지보수성이 향상
