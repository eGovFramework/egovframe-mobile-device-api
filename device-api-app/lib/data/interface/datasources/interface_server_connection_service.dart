import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';

/// Interface 서버 연결 확인
class InterfaceServerConnectionService {
  static final InterfaceServerConnectionService _instance = InterfaceServerConnectionService._internal();
  factory InterfaceServerConnectionService() => _instance;
  InterfaceServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() {
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getInterfaceUrl('/selectInterfaceInfo.do')),
      featureName: 'Interface',
      method: 'POST',
      body: const {'userId': '', 'userPw': ''},
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
