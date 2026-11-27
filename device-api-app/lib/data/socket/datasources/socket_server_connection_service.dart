import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

/// 소켓 서버 연결 확인
class SocketServerConnectionService {
  static final SocketServerConnectionService _instance = SocketServerConnectionService._internal();
  factory SocketServerConnectionService() => _instance;
  SocketServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getSocketUrl('/selectSocketMessageInfoList.do'))
          .replace(queryParameters: {'uuid': uuid}),
      featureName: 'Socket',
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
