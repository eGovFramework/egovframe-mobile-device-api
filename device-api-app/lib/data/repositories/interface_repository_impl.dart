import 'package:egovframe_mobile_deviceapi_app/data/datasources/interface_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/interface_repository.dart';

class InterfaceRepositoryImpl implements InterfaceRepository {
  InterfaceRepositoryImpl();

  @override
  Future<Map<String, dynamic>> login(String id, String password) async {
    return InterfaceService.login(id, password);
  }

  @override
  Future<Map<String, dynamic>> register(
    String id,
    String password,
    String email,
  ) async {
    return InterfaceService.register(id, password, email);
  }

  @override
  Future<bool> checkAccountExists(
    String id,
    String password,
    String email,
  ) async {
    return InterfaceService.checkAccountExists(id, password, email);
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  }) async {
    return InterfaceService.getUserInfo(
      userId,
      userPw,
      isPasswordHashed: isPasswordHashed,
    );
  }

  @override
  Future<Map<String, dynamic>> withdraw(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  }) async {
    return InterfaceService.withdraw(
      userId,
      userPw,
      isPasswordHashed: isPasswordHashed,
    );
  }
}
