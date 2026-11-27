import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/server_connection_result.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

/// 파일 읽기/쓰기 서버 연결 확인
class FileReadWriteServerConnectionService {
  static final FileReadWriteServerConnectionService _instance = FileReadWriteServerConnectionService._internal();
  factory FileReadWriteServerConnectionService() => _instance;
  FileReadWriteServerConnectionService._internal();

  Future<bool> isNetworkAvailable() => DeviceApiClient.isNetworkAvailable();

  Future<ServerConnectionResult> checkServerConnection() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    return DeviceApiClient.probe(
      url: Uri.parse(AppConfig.getFileReadWriteUrl('/selectFileReaderWriterInfoList.do'))
          .replace(queryParameters: {'uuid': uuid}),
      featureName: 'File read write',
    );
  }

  Future<bool> isServerConnected() async {
    final result = await checkServerConnection();
    return result == ServerConnectionResult.connected;
  }
}
