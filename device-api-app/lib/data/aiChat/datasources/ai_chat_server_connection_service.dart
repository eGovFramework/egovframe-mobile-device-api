import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

/// AI Chat 서버 연결 확인
class AiChatServerConnectionService {
  static final AiChatServerConnectionService _instance = AiChatServerConnectionService._internal();
  factory AiChatServerConnectionService() => _instance;
  AiChatServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    return DeviceApiClient.probe(
      url: Uri.parse(
        AppConfig.getAiChatUrl('/selectAiChatInfoList.do'),
      ).replace(queryParameters: {'uuid': uuid}),
      featureName: 'AI chat',
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
