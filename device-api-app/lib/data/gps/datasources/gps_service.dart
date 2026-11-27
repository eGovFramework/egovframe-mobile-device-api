import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:geolocator/geolocator.dart';

/// GPS 센서·서버 HTTP 통신 (Domain Entity 미사용)
class GpsService {
  /// 현재 위치(Position) 조회
  static Future<Position?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 활성화해주세요.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다. 설정에서 위치 권한을 허용해주세요.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다. 설정에서 위치 권한을 허용해주세요.');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
  }

  /// GPS 정보 서버 저장
  static Future<bool> insertGpsInfo({
    required String uuid,
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    try {
      final url = Uri.parse(AppConfig.getGpsUrl('/insertGPSInfo.do'));
      final body = {
        'uuid': uuid,
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'accrcy': accuracy?.toString() ?? '0',
        'useYn': 'Y',
      };

      final response = await DeviceApiClient.post(
        url,
        body: body,
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// GPS 정보 목록 서버 조회 (원시 JSON 항목)
  static Future<List<Map<String, dynamic>>> fetchGpsInfoList(String uuid) async {
    try {
      final url = Uri.parse(AppConfig.getGpsUrl('/selectGPSInfoList.do'))
          .replace(queryParameters: {'uuid': uuid});
      final response = await DeviceApiClient.get(url);

      if (response.statusCode != 200) {
        return [];
      }

      final value = response.jsonValue;
      if (value is List) {
        return value
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }

      return response.list('gpsInfoList');
    } catch (_) {
      return [];
    }
  }

  /// GPS 단건 삭제 (sn + uuid)
  static Future<bool> deleteGpsInfo({
    required int sn,
    required String uuid,
  }) async {
    try {
      final url = Uri.parse(AppConfig.getGpsUrl('/deleteGPSInfo.do'))
          .replace(queryParameters: {
        'sn': sn.toString(),
        'uuid': uuid,
      });
      final response = await DeviceApiClient.delete(url);

      return response.isSuccess;
    } catch (_) {
      return false;
    }
  }
}
