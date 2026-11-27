import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';

/// IoT 메시지 REST (device-api-web /iot)
class IotRemoteService {
  IotRemoteService._();

  /// 서버 프로파일의 MQTT 값. 여기서는 브로커에 접속하지 않는다.
  static Future<IotBrokerConfig?> loadBrokerConfig(
    IotBrokerConfig current,
  ) async {
    final uri = Uri.parse(AppConfig.getIotUrl('/mqttConfig.do'));
    try {
      final resp = await DeviceApiClient.get(uri);
      if (!resp.isSuccess) return null;
      final json = resp.json;
      if (json == null) return null;

      final enabled = json['enabled'] == true;
      final portValue = json['port'];
      final port = portValue is int
          ? portValue
          : int.tryParse('$portValue') ?? current.port;
      final deviceId = (json['deviceId'] ?? '').toString().trim();

      if (!enabled) {
        return current.copyWith(
          enabled: false,
          host: '',
          username: '',
          password: '',
          port: port,
          deviceId: deviceId.isEmpty ? current.deviceId : deviceId,
        );
      }

      return current.copyWith(
        enabled: true,
        host: (json['host'] ?? '').toString().trim(),
        port: port,
        username: (json['username'] ?? '').toString(),
        password: (json['password'] ?? '').toString(),
        deviceId: deviceId.isEmpty ? current.deviceId : deviceId,
      );
    } catch (e) {
      appLog('IotRemoteService.loadBrokerConfig failed: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postIotMessageInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getIotUrl('/insertIotMessageInfo.do'));
    try {
      final resp = await DeviceApiClient.post(uri, body: fields);
      if (resp.statusCode != 200) return null;
      return resp.json;
    } catch (e) {
      appLog('IotRemoteService.postIotMessageInfo failed: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchIotMessageList(
    String uuid,
  ) async {
    if (uuid.isEmpty) {
      return [];
    }
    final uri = Uri.parse(
      AppConfig.getIotUrl('/selectIotMessageInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);
      if (resp.statusCode != 200) return [];

      return resp.list('iotMessageInfoList');
    } catch (e) {
      appLog('IotRemoteService.fetchIotMessageList failed: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> deleteIotMessageInfo(String uuid) async {
    final uri = Uri.parse(
      AppConfig.getIotUrl('/deleteIotMessageInfo.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);
      if (resp.statusCode != 200) return null;
      return resp.json;
    } catch (e) {
      appLog('IotRemoteService.deleteIotMessageInfo failed: $e');
      return null;
    }
  }
}
