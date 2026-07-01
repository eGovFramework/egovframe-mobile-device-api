import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/interface_info.dart';
import '../../utils/app_logger.dart';
import '../../utils/password_encryption.dart';

class InterfaceService {
  static Future<Map<String, dynamic>> login(String id, String password) async {
    try {
      final clientHash = PasswordEncryption.encryptPassword(password, id);

      final uri = Uri.parse(AppConfig.getInterfaceUrl('/selectInterfaceInfo.do'));

      final body = {
        'userId': id,
        'userPw': clientHash,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        return {
          'success': true,
          'data': jsonResponse,
        };
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      AppLogger.e('Login API 오류', e);
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }

  // 회원가입 API 호출
  static Future<Map<String, dynamic>> register(String id, String password, String email) async {
    try {
      final uuid = await DeviceIdService.getDeviceId();

      final clientHash = PasswordEncryption.encryptPassword(password, id);

      final uri = Uri.parse(AppConfig.getInterfaceUrl('/insertInterfaceInfo.do'));

      final body = {
        'userId': id,
        'userPw': clientHash,
        'emails': email,
        'uuid': uuid,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        return {
          'success': true,
          'data': jsonResponse,
        };
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      AppLogger.e('회원가입 API 오류', e);
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
      AppLogger.e('계정 존재 여부 확인 오류', e);
      return false;
    }
  }

  // 사용자 정보 조회 API 호출
  static Future<Map<String, dynamic>> getUserInfo(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  }) async {
    try {
      final clientHash = isPasswordHashed
          ? userPw
          : PasswordEncryption.encryptPassword(userPw, userId);

      final uri = Uri.parse(AppConfig.getInterfaceUrl('/selectInterfaceInfo.do'));

      final body = {
        'userId': userId,
        'userPw': clientHash,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final interfaceInfo = jsonResponse['interfaceInfo'] as Map<String, dynamic>?;
        if (interfaceInfo != null) {
          final userInfo = UserInfo.fromJson(interfaceInfo);
          return {
            'success': true,
            'data': userInfo.toJson(),
          };
        } else {
          return {
            'success': false,
            'message': '인터페이스 정보를 찾을 수 없습니다.',
          };
        }
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      AppLogger.e('사용자 정보 조회 API 오류', e);
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }

  // 회원탈퇴 API 호출
  static Future<Map<String, dynamic>> withdraw(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  }) async {
    try {
      final clientHash = isPasswordHashed
          ? userPw
          : PasswordEncryption.encryptPassword(userPw, userId);

      final uri = Uri.parse(AppConfig.getInterfaceUrl('/deleteInterfaceInfo.do'));

      final body = {
        'userId': userId,
        'userPw': clientHash,
      };

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        return {
          'success': true,
          'data': jsonResponse,
        };
      } else {
        return {
          'success': false,
          'message': '서버 연결 실패 (상태 코드: ${response.statusCode})',
        };
      }
    } catch (e) {
      AppLogger.e('회원탈퇴 API 오류', e);
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }
}
