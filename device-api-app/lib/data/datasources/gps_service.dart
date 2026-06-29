import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/gps_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GpsService {
  /// 현재 위치 정보를 가져오는 메서드
  static Future<Position?> getCurrentLocation() async {
    try {
      print('GPS 위치 정보를 가져오는 중...');

      // 위치 서비스 활성화 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('위치 서비스가 비활성화되어 있습니다.');
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

      // 디버깅: 위치 정보 로그 출력
      print('=== GPS 위치 정보 ===');
      print('위도(Latitude): ${position.latitude}');
      print('경도(Longitude): ${position.longitude}');
      print('고도(Altitude): ${position.altitude}m');
      print('정확도(Accuracy): ${position.accuracy}m');
      print('속도(Speed): ${position.speed}m/s');
      print('==================');

      return position;
    } catch (e) {
      print('GPS 위치 정보 읽기 실패: $e');
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
      
      print('GPS 정보 서버 저장 API Request URL: $url');
      print('GPS 정보 서버 저장 API Request Body: $body');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print('GPS 정보 서버 저장 API Response Status: ${response.statusCode}');
      print('GPS 정보 서버 저장 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('GPS 정보 서버 저장 성공');
        return true;
      } else {
        print('GPS 정보 서버 저장 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('GPS 정보 서버 저장 오류: $e');
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

      print('GPS 정보 목록 조회 API Response: status=${response.statusCode}');
      print('GPS 정보 목록 조회 API Response Body: ${response.body}');

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
          print('GPS 정보 목록이 없습니다.');
          return [];
        }
      } else {
        print('GPS 정보 목록 로드 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('GPS 정보 목록 로드 오류: $e');
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
        print('GPS 정보 삭제 성공');
        return true;
      } else {
        print('GPS 정보 삭제 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('GPS 정보 삭제 오류: $e');
      return false;
    }
  }
}