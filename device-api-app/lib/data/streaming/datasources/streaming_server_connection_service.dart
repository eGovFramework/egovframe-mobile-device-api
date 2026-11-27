import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

/// Streaming 서버 연결 확인
class StreamingServerConnectionService {
  static final StreamingServerConnectionService _instance = StreamingServerConnectionService._internal();
  factory StreamingServerConnectionService() => _instance;
  StreamingServerConnectionService._internal();

  Future<ServerConnectionResult> checkServerConnection() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getStreamingUrl('/mediaInfoList.do'))
          .replace(queryParameters: {'uuid': uuid}),
      featureName: 'Streaming',
      method: 'POST',
      checkNetwork: false,
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
