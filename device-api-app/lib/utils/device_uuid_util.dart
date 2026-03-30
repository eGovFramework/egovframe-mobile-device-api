import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/device_service.dart';

class DeviceUuidUtil {
  static Future<String> getDeviceUuid() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        try {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          if (androidInfo.id.isNotEmpty) {
            return androidInfo.id;
          }
        } catch (e) {
          print('Android DeviceInfo UUID 가져오기 실패: $e');
        }
      } else if (Platform.isIOS) {
        try {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          final identifier = iosInfo.identifierForVendor;
          if (identifier != null && identifier.isNotEmpty) {
            return identifier;
          }
        } catch (e) {
          print('iOS DeviceInfo UUID 가져오기 실패: $e');
        }
      }
    } catch (e) {
      print('DeviceInfoPlugin 전체 실패: $e');
    }
    
    try {
      return await DeviceService.getPersistentUuid();
    } catch (e) {
      print('Persistent UUID 가져오기 실패: $e');
      return 'Unknown';
    }
  }
}

