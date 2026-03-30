import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_storage_info/flutter_storage_info.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device 관련 로컬 정보 수집 유틸리티
class DeviceService {
  static const String _persistentUuidKey = 'persistent_device_uuid';

  static Future<String> _generateFallbackUuid() async {
    final random = Random();
    final timestamp = DateTime.now()
        .add(Duration(hours: 9))
        .millisecondsSinceEpoch;
    final randomNum = random.nextInt(999999);
    return 'DEVICE_${timestamp}_$randomNum';
  }

  /// 앱 레벨 영구 UUID (앱 삭제 전까지 동일)
  static Future<String> getPersistentUuid() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_persistentUuidKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final generated = await _generateFallbackUuid();
    await prefs.setString(_persistentUuidKey, generated);
    return generated;
  }

  /// 네트워크 연결 타입(WiFi/Mobile/Ethernet/Unknown)
  static Future<String> getConnectionType() async {
    try {
      final result = await Connectivity().checkConnectivity();
      switch (result.first) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        default:
          return 'Unknown';
      }
    } catch (_) {
      return 'Unknown';
    }
  }

  /// 앱 버전
  static Future<String> getPackageVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return 'Unknown';
    }
  }

  /// Android 기기명(브랜드/모델 기반) 계산
  static String _composeAndroidDeviceName(AndroidDeviceInfo info) {
    final brand = info.brand;
    final model = info.model;
    final manufacturer = info.manufacturer;

    if (brand.isNotEmpty && model.isNotEmpty) return '$brand $model';
    if (manufacturer.isNotEmpty && model.isNotEmpty)
      return '$manufacturer $model';
    if (model.isNotEmpty) return model;
    if (brand.isNotEmpty) return brand;
    if (manufacturer.isNotEmpty) return manufacturer;
    return 'Android Device';
  }

  /// OS 문자열 계산 (Android: release 우선, 없으면 API 레벨)
  static String _composeAndroidOs(AndroidDeviceInfo info) {
    final release = info.version.release;
    final sdkInt = info.version.sdkInt;
    if (release != null && release.isNotEmpty) return 'Android $release';
    if (sdkInt != null) return 'Android API $sdkInt';
  }

  /// iOS OS 문자열 계산
  static String _composeIosOs(IosDeviceInfo info) {
    final v = info.systemVersion;
    return (v != null && v.isNotEmpty) ? 'iOS $v' : 'iOS';
  }

  /// 로컬 디바이스 정보를 수집해 Domain 엔티티로 반환
  static Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final uuid = await getPersistentUuid();
    final connectionType = await getConnectionType();
    // Program Version: Dart 런타임 버전을 표시
    final dartVersion = Platform.version.split(' ').first; // e.g., 3.5.2
    final pgVer = 'Dart $dartVersion';

    // 연락처 개수
    String? telno;
    try {
      final granted = await FlutterContacts.requestPermission(readonly: true);
      if (granted) {
        final contacts = await FlutterContacts.getContacts(
          withProperties: false,
        );
        telno = contacts.length.toString();
      }
    } catch (_) {}

    // 디바이스 스토리지 용량
    int strgeInfo;
    try {
      // total: 총 용량에서 System OS 용량 제외
      int? totalSpace = await FlutterStorageInfo.storageTotalSpace;
      int? freeSpace = await FlutterStorageInfo.storageFreeSpace;
      print('total: $totalSpace, free: $freeSpace');
      strgeInfo = totalSpace;
    } catch (_) {
      strgeInfo = 0;
    }

    String os = Platform.isAndroid
        ? 'Android'
        : Platform.isIOS
        ? 'iOS'
        : Platform.operatingSystem;
    String deviceNm = Platform.isAndroid
        ? 'Android Device'
        : Platform.isIOS
        ? 'iOS Device'
        : '${Platform.operatingSystem} Device';

    try {
      if (Platform.isAndroid) {
        final info = await deviceInfoPlugin.androidInfo;
        os = _composeAndroidOs(info);
        deviceNm = _composeAndroidDeviceName(info);
      } else if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        os = _composeIosOs(info);
        deviceNm = info.name ?? 'iOS Device';
      }
    } catch (_) {
      /* ignore and use defaults */
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

  /// 서버: Device 목록 조회
  static Future<List<DeviceInfo>> fetchDeviceInfoList(String uuid) async {
    final uri = Uri.parse(
      AppConfig.getDeviceUrl('/selectDeviceInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(AppConfig.defaultTimeout);

      if (resp.statusCode == 200) {
        final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
        final list = (jsonMap['deviceInfoList'] as List<dynamic>? ?? []);
        return list
            .map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  /// 서버: Device 단건 조회
  static Future<DeviceInfo?> fetchDeviceInfoDetail(int sn) async {
    final uri = Uri.parse(
      AppConfig.getDeviceUrl('/selectDeviceInfo.do'),
    ).replace(queryParameters: {'sn': sn.toString()});
    try {
      final resp = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(AppConfig.defaultTimeout);
      if (resp.statusCode == 200) {
        final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
        final deviceInfoData = jsonMap['deviceInfo'] as Map<String, dynamic>?;
        if (deviceInfoData != null) {
          return DeviceInfo.fromJson(deviceInfoData);
        }
      }
    } catch (_) {}
    return null;
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
      'strgeInfo': info.strgeInfo.toString(),
    };

    print('=== Device 업로드 시작 ===');
    print('URL: $uri');
    print('Fields: $fields');

    try {
      final resp = await http
          .post(uri, body: fields)
          .timeout(AppConfig.defaultTimeout);

      print('응답 상태: ${resp.statusCode}');
      print('응답 본문: ${resp.body}');

      if (resp.statusCode == 200) {
        final jsonMap = json.decode(resp.body) as Map<String, dynamic>;

        final resultState = (jsonMap['resultState'] ?? '').toString();
        print('resultState: $resultState');

        if (resultState == 'OK') {
          return true;
        }

        final deviceVO = jsonMap['deviceAPIVO'] as Map<String, dynamic>?;
        if (deviceVO != null) {
          final useYn = (deviceVO['useYn'] ?? '').toString();
          print('useYn: $useYn');
          return useYn == 'OK';
        }
      }
    } catch (e) {
      print('업로드 오류: $e');
    }
    return false;
  }

  /// 서버: Device 삭제
  static Future<bool> deleteDeviceInfo(int sn) async {
    final uri = Uri.parse(
      AppConfig.getDeviceUrl('/deleteDeviceInfo.do'),
    ).replace(queryParameters: {'sn': sn.toString()});
    try {
      final resp = await http.delete(uri).timeout(AppConfig.defaultTimeout);

      final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
      final resultState = (jsonMap['resultState'] ?? '').toString();

      if (resultState == 'OK') {
        return true;
      }
    } catch (_) {}
    return false;
  }
}
