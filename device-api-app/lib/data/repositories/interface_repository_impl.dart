import 'package:egovframe_mobile_deviceapi_app/data/datasources/interface_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/interface_repository.dart';

class InterfaceRepositoryImpl implements InterfaceRepository {
  InterfaceRepositoryImpl();

  @override
  Future<String> getDeviceUUID() async {
    return await InterfaceService.getDeviceUUID();
  }

  @override
  Future<Map<String, dynamic>> login(String id, String password, String email) async {
    return await InterfaceService.login(id, password);
  }

  @override
  Future<Map<String, dynamic>> register(String id, String password, String email) async {
    return await InterfaceService.register(id, password, email);
  }

  @override
  Future<bool> checkAccountExists(String id, String password, String email) async {
    return await InterfaceService.checkAccountExists(id, password, email);
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(String userId, String userPw) async {
    return await InterfaceService.getUserInfo(userId, userPw);
  }

  @override
  Future<Map<String, dynamic>> withdraw(String userId, String userPw) async {
    return await InterfaceService.withdraw(userId, userPw);
  }
}

