import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

/// StreamingMedia 서버 HTTP 통신 (/stm REST)
class StreamingService {
  /// 멀티미디어 목록 조회 (mediaInfoList.do)
  static Future<({String resultState, List<Map<String, dynamic>> items})>
      fetchMediaInfoList() async {
    final uri = Uri.parse(AppConfig.getStreamingUrl('/mediaInfoList.do'));

    try {
      final uuid = await DeviceUuidUtil.getDeviceUuid();
      final resp = await DeviceApiClient.post(uri, body: {'uuid': uuid});

      if (resp.statusCode != 200) {
        return (resultState: 'FAIL', items: <Map<String, dynamic>>[]);
      }

      return (
        resultState: resp.resultState ?? '',
        items: resp.list('resultSet'),
      );
    } catch (e) {
      appLog('StreamingService.fetchMediaInfoList failed: $e');
      return (resultState: 'FAIL', items: <Map<String, dynamic>>[]);
    }
  }

  /// 재생횟수 업데이트 (updateMediaInfoRevivCo.do)
  static Future<Map<String, dynamic>?> updateMediaInfoRevivCo(int sn) async {
    final uri = Uri.parse(AppConfig.getStreamingUrl('/updateMediaInfoRevivCo.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: {'sn': sn.toString()});

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('StreamingService.updateMediaInfoRevivCo failed: $e');
      return null;
    }
  }

  static String buildStreamingUrl({
    required int sn,
    int fileSn = 0,
    required String uuid,
  }) {
    final encodedUuid = Uri.encodeQueryComponent(uuid);
    if (fileSn > 0) {
      return '${AppConfig.currentBaseUrl}/mda/downloadMediaFile.do?fileSn=$fileSn&uuid=$encodedUuid';
    }
    return AppConfig.getStreamingUrl('/getMediaStreaming.do?sn=$sn&uuid=$encodedUuid');
  }
}
