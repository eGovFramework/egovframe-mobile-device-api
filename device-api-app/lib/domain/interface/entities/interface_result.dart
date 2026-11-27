import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/interface_message_keys.dart';

sealed class InterfaceSessionResult {
  const InterfaceSessionResult();
}

class InterfaceSessionValid extends InterfaceSessionResult {
  final String userId;
  final String password;

  const InterfaceSessionValid({required this.userId, required this.password});
}

class InterfaceSessionExpired extends InterfaceSessionResult {
  const InterfaceSessionExpired();
}

class InterfaceSessionNone extends InterfaceSessionResult {
  const InterfaceSessionNone();
}

sealed class InterfaceLoginResult {
  const InterfaceLoginResult();
}

class InterfaceLoginSuccess extends InterfaceLoginResult {
  final String userId;
  final String message;

  const InterfaceLoginSuccess({
    required this.userId,
    this.message = InterfaceMessageKeys.loginSuccess,
  });
}

class InterfaceLoginFailure extends InterfaceLoginResult {
  final String message;

  const InterfaceLoginFailure(this.message);
}

sealed class InterfaceRegisterResult {
  const InterfaceRegisterResult();
}

class InterfaceRegisterSuccess extends InterfaceRegisterResult {
  final String message;

  const InterfaceRegisterSuccess([
    this.message = InterfaceMessageKeys.registerSuccess,
  ]);
}

class InterfaceRegisterAccountExists extends InterfaceRegisterResult {
  final String message;

  const InterfaceRegisterAccountExists([
    this.message = InterfaceMessageKeys.registerAccountExists,
  ]);
}

class InterfaceRegisterFailure extends InterfaceRegisterResult {
  final String message;

  const InterfaceRegisterFailure(this.message);
}

sealed class InterfaceUserInfoResult {
  const InterfaceUserInfoResult();
}

class InterfaceUserInfoSuccess extends InterfaceUserInfoResult {
  final Map<String, dynamic> userInfo;

  const InterfaceUserInfoSuccess(this.userInfo);
}

class InterfaceUserInfoFailure extends InterfaceUserInfoResult {
  final String message;

  const InterfaceUserInfoFailure(this.message);
}

sealed class InterfaceWithdrawResult {
  const InterfaceWithdrawResult();
}

class InterfaceWithdrawSuccess extends InterfaceWithdrawResult {
  final String message;

  const InterfaceWithdrawSuccess([
    this.message = InterfaceMessageKeys.withdrawSuccess,
  ]);
}

class InterfaceWithdrawFailure extends InterfaceWithdrawResult {
  final String message;

  const InterfaceWithdrawFailure(this.message);
}

sealed class InterfaceLogoutResult {
  const InterfaceLogoutResult();
}

class InterfaceLogoutSuccess extends InterfaceLogoutResult {
  final String message;

  const InterfaceLogoutSuccess([
    this.message = InterfaceMessageKeys.logoutSuccess,
  ]);
}
