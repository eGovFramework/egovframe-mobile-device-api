import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GpsService {
  /// 현재 위치 정보를 가져오는 메서드
  static Future<Position?> getCurrentLocation() async {
    try {

      // 위치 서비스 활성화 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 활성화해주세요.');
      }

      // 위치 권한 확인
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

      // 현재 위치 가져오기
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      return position;
    } catch (e) {
      AppLogger.e('현재 위치 조회 오류', e);
      rethrow;
    }
  }

  /// GPS 정보를 서버에 저장하는 메서드
  static Future<bool> saveGpsInfo(GpsInfo gpsInfo) async {
    try {
      final url = Uri.parse(AppConfig.getGpsUrl('/insertGPSInfo.do'));
      
      final body = {
        'uuid': gpsInfo.uuid,
        'lat': gpsInfo.latitude.toString(),
        'lon': gpsInfo.longitude.toString(),
        'accrcy': gpsInfo.accrcy?.toString() ?? '0',
        'useYn': 'Y',
      };
      
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );


      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppLogger.e('GPS 정보 저장 오류', e);
      return false;
    }
  }

  /// GPS 정보 목록을 서버에서 가져오는 메서드
  static Future<List<GpsInfo>> loadGpsInfoList(String uuid) async {
    try {
      final url = Uri.parse(
        AppConfig.getGpsUrl('/selectGPSInfoList.do'),
      ).replace(queryParameters: {'uuid': uuid});
      final response = await http.get(url);


      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        List<dynamic>? data;
        
        if (jsonResponse is List) {
          data = jsonResponse;
        } else if (jsonResponse is Map<String, dynamic>) {
          data = jsonResponse['gpsInfoList'];
        }
        
        if (data != null) {
          return data.map((json) {
            final item = json as Map<String, dynamic>;
            final serverInfo = GpsInfoServer.fromJson(item);
            return GpsInfo(
              sn: serverInfo.sn,
              uuid: serverInfo.uuid,
              latitude: serverInfo.lat,
              longitude: serverInfo.lon,
              accrcy: serverInfo.accrcy,
              timestamp:
                  serverInfo.regDate ??
                  serverInfo.updDate ??
                  DateTime.now().add(Duration(hours: 9)),
            );
          }).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.e('GPS 목록 조회 오류', e);
      return [];
    }
  }

  static Future<bool> deleteGpsInfoBySn({
    required String uuid,
    required int sn,
  }) async {
    try {
      final url = Uri.parse(
        AppConfig.getGpsUrl('/deleteGPSInfo.do'),
      ).replace(queryParameters: {'uuid': uuid, 'sn': sn.toString()});
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppLogger.e('GPS 정보 삭제 오류', e);
      return false;
    }
  }
}