import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';

/// Accelerator 서버 연결 확인
class AcceleratorServerConnectionService {
  static final AcceleratorServerConnectionService _instance = AcceleratorServerConnectionService._internal();
  factory AcceleratorServerConnectionService() => _instance;
  AcceleratorServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() {
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getAcceleratorUrl('/selectAcceleratorInfoList.do')),
      featureName: 'Accelerator',
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
