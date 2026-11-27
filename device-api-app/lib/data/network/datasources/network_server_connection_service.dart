import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';

/// 네트워크 서버 연결 확인
class NetworkServerConnectionService {
  static final NetworkServerConnectionService _instance = NetworkServerConnectionService._internal();
  factory NetworkServerConnectionService() => _instance;
  NetworkServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() {
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getNetworkUrl('/selectNetworkInfoList.do')),
      featureName: 'Network',
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
