import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/interface_info.dart';
import '../../utils/password_encryption.dart';

class InterfaceService {

  static Future<String> getDeviceUUID() async {
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor ?? 'Unknown';
      }
      
      return 'Unknown';
    } catch (e) {
      print('Error getting deviceInfo UUID: $e');
      return 'Unknown';
    }
  }

  // 로그인 API 호출
  static Future<Map<String, dynamic>> login(String id, String password) async {
    try {
      final uuid = await getDeviceUUID();
      
      final encryptedPassword = PasswordEncryption.hashPasswordWithSalt(password);
      
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/selectInterfaceInfo.do'));
      
      final body = {
        'userId': id,
        'userPw': encryptedPassword,
      };

      print('Login API Request URL: $uri');
      print('Login API Request Body: $body');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Login API Response: $jsonResponse');
        
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
      print('Login API Error: $e');
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
      
      final encryptedPassword = PasswordEncryption.hashPasswordWithSalt(password);
      
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/insertInterfaceInfo.do'));
      
      final body = {
        'userId': id,
        'userPw': encryptedPassword,
        'emails': email,
        'uuid': uuid,
      };

      print('Register API Request URL: $uri');
      print('Register API Request Body: $body');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Register API Response: $jsonResponse');
        
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
      print('Register API Error: $e');
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
      print('Check account exists error: $e');
      return false;
    }
  }

  // 사용자 정보 조회 API 호출
  static Future<Map<String, dynamic>> getUserInfo(String userId, String userPw) async {
    try {
      final encryptedPassword = PasswordEncryption.hashPasswordWithSalt(userPw);
      
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/selectInterfaceInfo.do'));
      
      final body = {
        'userId': userId,
        'userPw': encryptedPassword,
      };

      print('GetUserInfo API Request URL: $uri');
      print('GetUserInfo API Request Body: $body');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('GetUserInfo API Response: $jsonResponse');
        final interfaceInfo = jsonResponse['interfaceInfo'] as Map<String,dynamic>?;
        if(interfaceInfo != null){
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
      print('GetUserInfo API Error: $e');
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }

  // 회원탈퇴 API 호출
  static Future<Map<String, dynamic>> withdraw(String userId, String userPw) async {
    try {
      final encryptedPassword = PasswordEncryption.hashPasswordWithSalt(userPw);
      
      final uri = Uri.parse(AppConfig.getInterfaceUrl('/deleteInterfaceInfo.do'));
      
      final body = {
        'userId': userId,
        'userPw': encryptedPassword,
      };

      print('Withdraw API Request URL: $uri');
      print('Withdraw API Request Body: $body');

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Withdraw API Response: $jsonResponse');
        
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
      print('Withdraw API Error: $e');
      return {
        'success': false,
        'message': '오류가 발생했습니다: $e',
      };
    }
  }
}
