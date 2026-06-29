import 'package:egovframe_mobile_deviceapi_app/domain/repositories/interface_repository.dart';

class InterfaceUseCase {
  final InterfaceRepository repository;

  InterfaceUseCase(this.repository);

  Future<Map<String, dynamic>> login(String id, String password, String email) async {
    return await repository.login(id, password, email);
  }

  Future<Map<String, dynamic>> register(String id, String password, String email) async {
    return await repository.register(id, password, email);
  }

  Future<bool> checkAccountExists(String id, String password, String email) async {
    return await repository.checkAccountExists(id, password, email);
  }

  Future<Map<String, dynamic>> getUserInfo(String userId, String userPw) async {
    return await repository.getUserInfo(userId, userPw);
  }

  Future<Map<String, dynamic>> withdraw(String userId, String userPw) async {
    return await repository.withdraw(userId, userPw);
  }
}

