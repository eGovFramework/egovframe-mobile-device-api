import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';

/// 기기 정보 서버 연결 확인
class DeviceServerConnectionService {
  static final DeviceServerConnectionService _instance = DeviceServerConnectionService._internal();
  factory DeviceServerConnectionService() => _instance;
  DeviceServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() {
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getDeviceUrl('/selectDeviceInfoList.do')),
      featureName: 'Device',
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
