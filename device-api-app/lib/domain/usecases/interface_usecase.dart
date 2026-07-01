import 'package:egovframe_mobile_deviceapi_app/domain/interface_input_validator.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/interface_repository.dart';

class InterfaceUseCase {
  final InterfaceRepository repository;

  InterfaceUseCase(this.repository);

  Future<Map<String, dynamic>> login(String id, String password) async {
    try {
      InterfaceInputValidator.ensureLogin(userId: id, userPw: password);
      return await repository.login(id, password);
    } on FormatException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>> register(
    String id,
    String password,
    String email,
  ) async {
    try {
      InterfaceInputValidator.ensureRegister(
        userId: id,
        userPw: password,
        email: email,
      );
      return await repository.register(id, password, email);
    } on FormatException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<bool> checkAccountExists(
    String id,
    String password,
    String email,
  ) async {
    try {
      InterfaceInputValidator.ensureLogin(userId: id, userPw: password);
      return await repository.checkAccountExists(id, password, email);
    } on FormatException {
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserInfo(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  }) async {
    try {
      InterfaceInputValidator.ensureAuthenticatedRequest(
        userId: userId,
        userPw: userPw,
        isPasswordHashed: isPasswordHashed,
      );
      return await repository.getUserInfo(
        userId,
        userPw,
        isPasswordHashed: isPasswordHashed,
      );
    } on FormatException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>> withdraw(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  }) async {
    try {
      InterfaceInputValidator.ensureAuthenticatedRequest(
        userId: userId,
        userPw: userPw,
        isPasswordHashed: isPasswordHashed,
      );
      return await repository.withdraw(
        userId,
        userPw,
        isPasswordHashed: isPasswordHashed,
      );
    } on FormatException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }
}
