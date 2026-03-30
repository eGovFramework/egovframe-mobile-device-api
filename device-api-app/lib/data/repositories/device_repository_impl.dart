import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/device_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl();

  String _generateFallbackUuid() {
    final random = Random();
    final timestamp = DateTime.now().add(Duration(hours: 9)).millisecondsSinceEpoch;
    final randomNum = random.nextInt(999999);
    return 'DEVICE_${timestamp}_$randomNum';
  }

  Future<String> _getPersistentUuid() async => await DeviceService.getPersistentUuid();

  Future<Map<String, String>> _getSafeDeviceInfo() async {
    final deviceInfo = <String, String>{};
    final persistentUuid = await _getPersistentUuid();
    
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        try {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          
          deviceInfo['uuid'] = persistentUuid;
          
          // Android 버전 정보 개선
          final release = androidInfo.version.release;
          final sdkInt = androidInfo.version.sdkInt;
          if (release != null && release.isNotEmpty) {
            deviceInfo['os'] = 'Android $release';
          } else if (sdkInt != null) {
            deviceInfo['os'] = 'Android API $sdkInt';
          } else {
            deviceInfo['os'] = 'Android';
          }
          deviceInfo['brand'] = androidInfo.brand ?? 'Unknown';
          deviceInfo['model'] = androidInfo.model ?? 'Unknown';
          deviceInfo['manufacturer'] = androidInfo.manufacturer ?? 'Unknown';
          deviceInfo['device'] = androidInfo.device ?? 'Unknown';
          deviceInfo['product'] = androidInfo.product ?? 'Unknown';
          deviceInfo['hardware'] = androidInfo.hardware ?? 'Unknown';
          deviceInfo['sdkInt'] = androidInfo.version.sdkInt?.toString() ?? 'Unknown';
          
          final brand = deviceInfo['brand'] ?? '';
          final model = deviceInfo['model'] ?? '';
          final manufacturer = deviceInfo['manufacturer'] ?? '';
          
          String deviceName = 'Android Device';
          if (brand.isNotEmpty && model.isNotEmpty) {
            deviceName = '$brand $model';
          } else if (manufacturer.isNotEmpty && model.isNotEmpty) {
            deviceName = '$manufacturer $model';
          } else if (model.isNotEmpty) {
            deviceName = model;
          } else if (brand.isNotEmpty) {
            deviceName = brand;
          } else if (manufacturer.isNotEmpty) {
            deviceName = manufacturer;
          }
          
          deviceInfo['deviceNm'] = deviceName;
          
        } catch (e) {
          print('Android 정보 조회 실패 (대안 방법): $e');
          deviceInfo['uuid'] = persistentUuid;
          deviceInfo['os'] = 'Android';
          deviceInfo['deviceNm'] = 'Android Device';
        }
      } else if (Platform.isIOS) {
        try {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          deviceInfo['uuid'] = persistentUuid;
          
          // iOS 버전 정보 개선
          final systemVersion = iosInfo.systemVersion;
          if (systemVersion != null && systemVersion.isNotEmpty) {
            deviceInfo['os'] = 'iOS $systemVersion';
          } else {
            deviceInfo['os'] = 'iOS';
          }
          
          deviceInfo['deviceNm'] = iosInfo.name ?? 'iOS Device';
          deviceInfo['model'] = iosInfo.model ?? 'Unknown';
          deviceInfo['systemName'] = iosInfo.systemName ?? 'Unknown';
        } catch (e) {
          print('iOS 정보 조회 실패 (대안 방법): $e');
          deviceInfo['uuid'] = persistentUuid;
          deviceInfo['os'] = 'iOS';
          deviceInfo['deviceNm'] = 'iOS Device';
        }
      }
    } catch (e) {
      print('DeviceInfoPlugin 전체 실패: $e');
      deviceInfo['uuid'] = persistentUuid;
      deviceInfo['os'] = Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : Platform.operatingSystem;
      deviceInfo['deviceNm'] = Platform.isAndroid ? 'Android Device' : Platform.isIOS ? 'iOS Device' : '${Platform.operatingSystem} Device';
    }
    
    return deviceInfo;
  }

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
