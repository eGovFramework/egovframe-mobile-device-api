import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_storage_info/flutter_storage_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Device 로컬 정보 수집·서버 HTTP 통신 (Domain Entity 미사용)
class DeviceService {
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

  static String _composeAndroidDeviceName(AndroidDeviceInfo info) {
    final brand = info.brand;
    final model = info.model;
    final manufacturer = info.manufacturer;

    if (brand.isNotEmpty && model.isNotEmpty) return '$brand $model';
    if (manufacturer.isNotEmpty && model.isNotEmpty) {
      return '$manufacturer $model';
    }
    if (model.isNotEmpty) return model;
    if (brand.isNotEmpty) return brand;
    if (manufacturer.isNotEmpty) return manufacturer;
    return 'Android Device';
  }

  static String _composeAndroidOs(AndroidDeviceInfo info) {
    final release = info.version.release;
    final sdkInt = info.version.sdkInt;
    if (release.isNotEmpty) return 'Android $release';
    return 'Android API $sdkInt';
  }

  static String _composeIosOs(IosDeviceInfo info) {
    final v = info.systemVersion;
    return v.isNotEmpty ? 'iOS $v' : 'iOS';
  }

  /// 로컬 디바이스 정보 수집 (Repository에서 Entity로 변환)
  static Future<Map<String, dynamic>> collectLocalDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final uuid = await DeviceIdService.getDeviceId();
    final connectionType = await getConnectionType();
    final dartVersion = Platform.version.split(' ').first;
    final pgVer = 'Dart $dartVersion';

    String? telno;
    try {
      final hasPermission = await FlutterContacts.requestPermission(
        readonly: true,
      );
      if (!hasPermission) {
        appLog('연락처 권한이 허용되지 않아 개수를 조회할 수 없습니다.');
      } else {
        final contacts = await FlutterContacts.getContacts(
          withProperties: false,
        );
        telno = contacts.length.toString();
      }
    } catch (e) {
      appLog('연락처 개수 조회 오류: $e');
    }

    int strgeInfo = 0;
    try {
      strgeInfo = await FlutterStorageInfo.storageTotalSpace;
    } catch (_) {}

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
        deviceNm = info.name.isNotEmpty ? info.name : 'iOS Device';
      }
    } catch (_) {}

    return {
      'sn': 0,
      'uuid': uuid,
      'os': os,
      'ntwrkDeviceInfo': connectionType,
      'pgVer': pgVer,
      'deviceNm': deviceNm,
      'useYn': 'Y',
      'telno': telno,
      'strgeInfo': strgeInfo,
    };
  }

  /// 서버: Device 목록 조회 (원시 JSON 항목)
  static Future<List<Map<String, dynamic>>> fetchDeviceInfoList(String uuid) async {
    final uri = Uri.parse(
      AppConfig.getDeviceUrl('/selectDeviceInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('deviceInfoList');
    } catch (_) {
      return [];
    }
  }

  /// 서버: Device 단건 조회 (원시 JSON)
  static Future<Map<String, dynamic>?> fetchDeviceInfoDetail(
    int sn,
    String uuid,
  ) async {
    final uri = Uri.parse(
      AppConfig.getDeviceUrl('/selectDeviceInfo.do'),
    ).replace(queryParameters: {
      'sn': sn.toString(),
      'uuid': uuid,
    });

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      final deviceInfoData = resp.json?['deviceInfo'];
      if (deviceInfoData is Map<String, dynamic>) {
        return deviceInfoData;
      }
    } catch (_) {}

    return null;
  }

  /// 서버: Device 등록 (응답 본문 반환)
  static Future<Map<String, dynamic>?> postDeviceInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getDeviceUrl('/insertDeviceInfo.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (_) {
      return null;
    }
  }

  /// 서버: Device 삭제 (응답 본문 반환)
  static Future<Map<String, dynamic>?> deleteDeviceInfoRequest(
    int sn,
    String uuid,
  ) async {
    final uri = Uri.parse(
      AppConfig.getDeviceUrl('/deleteDeviceInfo.do'),
    ).replace(queryParameters: {
      'sn': sn.toString(),
      'uuid': uuid,
    });

    try {
      final resp = await DeviceApiClient.delete(uri);
      return resp.json;
    } catch (_) {
      return null;
    }
  }
}
