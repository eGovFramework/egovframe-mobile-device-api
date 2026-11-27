import 'package:egovframe_mobile_deviceapi_app/data/interface/datasources/interface_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/repositories/interface_repository.dart';

class InterfaceRemoteRepositoryImpl implements InterfaceRepository {
  InterfaceRemoteRepositoryImpl();

  @override
  Future<String> getDeviceUUID() async {
    return InterfaceService.getDeviceUUID();
  }

  @override
  Future<Map<String, dynamic>> login(String id, String password, String email) async {
    return InterfaceService.login(id, password);
  }

  @override
  Future<Map<String, dynamic>> register(String id, String password, String email) async {
    return InterfaceService.register(id, password, email);
  }

  @override
  Future<bool> checkAccountExists(String id, String password, String email) async {
    return InterfaceService.checkAccountExists(id, password, email);
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(String userId, String userPw) async {
    final response = await InterfaceService.fetchUserInfo(userId, userPw);

    if (response.statusCode != 200 || response.body == null) {
      return {
        'success': false,
        'message': response.statusCode == -1
            ? '오류가 발생했습니다.'
            : '서버 연결 실패 (상태 코드: ${response.statusCode})',
      };
    }

    final interfaceInfo = response.body!['interfaceInfo'] as Map<String, dynamic>?;
    if (interfaceInfo == null) {
      return {
        'success': false,
        'message': '인터페이스 정보를 찾을 수 없습니다.',
      };
    }

    final userInfo = UserInfo.fromJson(interfaceInfo);
    return {
      'success': true,
      'data': userInfo.toJson(),
    };
  }

  @override
  Future<Map<String, dynamic>> withdraw(String userId, String userPw) async {
    return InterfaceService.withdraw(userId, userPw);
  }
}
