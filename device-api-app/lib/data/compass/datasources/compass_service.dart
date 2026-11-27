import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:flutter_compass/flutter_compass.dart';

/// 나침반 센서 및 서버 HTTP 통신 (device-api-web /cps REST)
class CompassService {
  static Stream<CompassEvent>? compassEvents() => FlutterCompass.events;

  /// 서버: 나침반 정보 등록
  static Future<Map<String, dynamic>?> postCompassInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getCompassUrl('/insertCompassInfo.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('CompassService.postCompassInfo failed: $e');
      return null;
    }
  }

  /// 서버: 나침반 정보 목록 조회
  static Future<List<Map<String, dynamic>>> fetchCompassInfoList(
    String uuid,
  ) async {
    if (uuid.isEmpty) {
      return [];
    }
    final uri = Uri.parse(
      AppConfig.getCompassUrl('/selectCompassInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('compassInfoList');
    } catch (e) {
      appLog('CompassService.fetchCompassInfoList failed: $e');
      return [];
    }
  }

  /// 서버: 나침반 정보 삭제 (sn + uuid)
  static Future<Map<String, dynamic>?> deleteCompassInfo({
    required int sn,
    required String uuid,
  }) async {
    final uri = Uri.parse(
      AppConfig.getCompassUrl('/deleteCompassInfo.do'),
    ).replace(queryParameters: {'sn': sn.toString(), 'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('CompassService.deleteCompassInfo failed: $e');
      return null;
    }
  }
}
