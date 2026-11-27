import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';

/// GPS 서버 연결 확인
class GpsServerConnectionService {
  static final GpsServerConnectionService _instance = GpsServerConnectionService._internal();
  factory GpsServerConnectionService() => _instance;
  GpsServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() {
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getGpsUrl('/selectGPSInfoList.do')),
      featureName: 'GPS',
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
