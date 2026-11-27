import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class InterfaceService {
  static Future<String> getDeviceUUID() => DeviceUuidUtil.getDeviceUuid();

  // 로그인 API 호출. 비밀번호는 평문으로 보내고 서버가 BCrypt로 검증한다.
  static Future<Map<String, dynamic>> login(String id, String password) async {
    try {
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/selectInterfaceInfo.do'));
      
      final body = {
        'userId': id,
        'userPw': password,
      };


      final response = await DeviceApiClient.post(
        uri,
        body: body,
      );

      if (response.httpOk && response.json != null) {
        return {
          'success': true,
          'data': response.json,
        };
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }

  // 회원가입 API 호출
  static Future<Map<String, dynamic>> register(String id, String password, String email) async {
    try {
      final uuid = await getDeviceUUID();
      
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/insertInterfaceInfo.do'));
      
      final body = {
        'userId': id,
        'userPw': password,
        'emails': email,
        'uuid': uuid,
      };


      final response = await DeviceApiClient.post(
        uri,
        body: body,
      );

      if (response.httpOk && response.json != null) {
        return {
          'success': true,
          'data': response.json,
        };
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }

  // 계정 존재 여부 확인 (로그인 시도로 확인)
  static Future<bool> checkAccountExists(String id, String password, String email) async {
    try {
      final result = await login(id, password);
      
      if (result['success'] && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final interfaceInfo = data['interfaceInfo'];
        
        if (interfaceInfo != null) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 사용자 정보 조회 API (HTTP·원시 JSON)
  static Future<({int statusCode, Map<String, dynamic>? body})> fetchUserInfo(
    String userId,
    String userPw,
  ) async {
    try {
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/selectInterfaceInfo.do'));
      final body = {
        'userId': userId,
        'userPw': userPw,
      };

      final response = await DeviceApiClient.post(
            uri,
            body: body,
          );

      if (response.statusCode != 200) {
        return (statusCode: response.statusCode, body: null);
      }

      return (
        statusCode: response.statusCode,
        body: response.json,
      );
    } catch (_) {
      return (statusCode: -1, body: null);
    }
  }

  // 회원탈퇴 API 호출
  static Future<Map<String, dynamic>> withdraw(String userId, String userPw) async {
    try {
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/deleteInterfaceInfo.do'));
      
      final body = {
        'userId': userId,
        'userPw': userPw,
      };


      final response = await DeviceApiClient.delete(
        uri,
        body: body,
      );

      if (response.httpOk && response.json != null) {
        return {
          'success': true,
          'data': response.json,
        };
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }
}
