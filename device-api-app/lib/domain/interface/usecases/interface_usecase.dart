import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/repositories/interface_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/interface_message_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InterfaceUseCase {
  final InterfaceRepository repository;
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: false),
  );

  InterfaceUseCase(this.repository);

  Future<String> getDeviceUUID() => repository.getDeviceUUID();

  Future<InterfaceSessionResult> checkSavedSession() async {
    final loginStatus = await _storage.read(key: 'login');
    final savedUserId = await _storage.read(key: 'userId');
    final savedPassword = await _storage.read(key: 'password');
    final loginTimeStr = await _storage.read(key: 'loginTime');

    if (loginStatus == null || savedUserId == null || savedPassword == null) {
      return const InterfaceSessionNone();
    }

    if (loginTimeStr != null) {
      try {
        final loginTime = DateTime.parse(loginTimeStr);
        if (DateTime.now().difference(loginTime) > AppConfig.sessionTimeout) {
          await clearSession();
          return const InterfaceSessionExpired();
        }
      } catch (_) {
        await clearSession();
        return const InterfaceSessionExpired();
      }
    }

    return InterfaceSessionValid(userId: savedUserId, password: savedPassword);
  }

  Future<void> saveSession({
    required String userId,
    required String password,
  }) async {
    final now = DateTime.now();
    await _storage.write(key: 'password', value: password);
    await _storage.write(key: 'userId', value: userId);
    await _storage.write(key: 'login', value: 'true');
    await _storage.write(key: 'loginTime', value: now.toIso8601String());
  }

  Future<void> clearSession() async {
    await _storage.delete(key: 'password');
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'login');
    await _storage.delete(key: 'loginTime');
  }

  Future<InterfaceLoginResult> login(String id, String password) async {
    try {
      final result = await repository.login(id, password, '');

      if (result['success'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final interfaceInfo = data['interfaceInfo'];

        if (!_hasValidInterfaceInfo(interfaceInfo)) {
          return const InterfaceLoginFailure(
            InterfaceMessageKeys.loginUserNotFound,
          );
        }

        await saveSession(userId: id, password: password);
        return InterfaceLoginSuccess(userId: id);
      }

      return InterfaceLoginFailure(
        result['message']?.toString() ?? InterfaceMessageKeys.loginFailed,
      );
    } catch (e) {
      return InterfaceLoginFailure(
        '${InterfaceMessageKeys.genericErrorPrefix}$e',
      );
    }
  }

  /// 서버/SQLite 응답의 interfaceInfo가 유효한 사용자인지 확인
  bool _hasValidInterfaceInfo(dynamic interfaceInfo) {
    if (interfaceInfo == null) return false;
    if (interfaceInfo is! Map) return false;

    final userId = interfaceInfo['userId'] ?? interfaceInfo['USERID'];
    return userId != null && userId.toString().trim().isNotEmpty;
  }

  Future<InterfaceRegisterResult> register(
    String id,
    String password,
    String email,
  ) async {
    try {
      final accountExists = await repository.checkAccountExists(
        id,
        password,
        email,
      );

      if (accountExists) {
        return const InterfaceRegisterAccountExists();
      }

      final result = await repository.register(id, password, email);

      if (result['success'] == true) {
        await saveSession(userId: id, password: password);
        return const InterfaceRegisterSuccess();
      }

      return InterfaceRegisterFailure(
        '${InterfaceMessageKeys.registerFailedPrefix}${result['message']}',
      );
    } catch (e) {
      return InterfaceRegisterFailure(
        '${InterfaceMessageKeys.genericErrorPrefix}$e',
      );
    }
  }

  Future<InterfaceUserInfoResult> getUserInfo(
    String userId,
    String userPw,
  ) async {
    try {
      final result = await repository.getUserInfo(userId, userPw);

      if (result['success'] == true) {
        return InterfaceUserInfoSuccess(result['data'] ?? {});
      }

      return InterfaceUserInfoFailure(
        result['message']?.toString() ?? InterfaceMessageKeys.unknownError,
      );
    } catch (e) {
      return InterfaceUserInfoFailure(
        '${InterfaceMessageKeys.genericErrorPrefix}$e',
      );
    }
  }

  Future<InterfaceWithdrawResult> withdraw(String userId, String userPw) async {
    try {
      final result = await repository.withdraw(userId, userPw);

      if (result['success'] == true) {
        await clearSession();
        return const InterfaceWithdrawSuccess();
      }

      return InterfaceWithdrawFailure(
        '${InterfaceMessageKeys.withdrawFailedPrefix}${result['message']}',
      );
    } catch (e) {
      return InterfaceWithdrawFailure(
        '${InterfaceMessageKeys.genericErrorPrefix}$e',
      );
    }
  }

  Future<InterfaceLogoutResult> logout() async {
    await clearSession();
    return const InterfaceLogoutSuccess();
  }
}
