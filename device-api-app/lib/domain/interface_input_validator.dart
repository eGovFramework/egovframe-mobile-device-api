/// Interface API 입력 검증.
class InterfaceInputValidator {
  InterfaceInputValidator._();

  static const int userIdMaxLength = 20;
  static const int userPwMinLength = 6;
  static const int userPwMaxLength = 100;
  static const int emailMaxLength = 100;
  static const int clientHashMinLength = 40;
  static const int clientHashMaxLength = 48;

  static final RegExp _clientHashPattern = RegExp(r'^[A-Za-z0-9+/]+=*$');

  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validateUserId(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'ID를 입력해주세요';
    }
    if (trimmed.length > userIdMaxLength) {
      return '아이디는 $userIdMaxLength자 이내여야 합니다';
    }
    return null;
  }

  static String? validateUserPw(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (trimmed.length < userPwMinLength) {
      return '비밀번호는 $userPwMinLength자 이상이어야 합니다';
    }
    if (trimmed.length > userPwMaxLength) {
      return '비밀번호는 $userPwMaxLength자 이내여야 합니다';
    }
    return null;
  }

  static String? validateEmail(String? value, {bool required = false}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? '이메일을 입력해주세요' : null;
    }
    if (trimmed.length > emailMaxLength) {
      return '이메일은 $emailMaxLength자 이내여야 합니다';
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return '올바른 이메일 형식을 입력해주세요';
    }
    return null;
  }

  /// 로그인 입력 전체 검증.
  static String? validateLogin({required String userId, required String userPw}) {
    return validateUserId(userId) ?? validateUserPw(userPw);
  }

  /// 회원가입 입력 전체 검증.
  static String? validateRegister({
    required String userId,
    required String userPw,
    required String email,
  }) {
    return validateUserId(userId) ??
        validateUserPw(userPw) ??
        validateEmail(email, required: true);
  }

  static void ensureLogin({required String userId, required String userPw}) {
    final message = validateLogin(userId: userId, userPw: userPw);
    if (message != null) {
      throw FormatException(message);
    }
  }

  static void ensureRegister({
    required String userId,
    required String userPw,
    required String email,
  }) {
    final message = validateRegister(
      userId: userId,
      userPw: userPw,
      email: email,
    );
    if (message != null) {
      throw FormatException(message);
    }
  }

  /// 세션/해시 비밀번호로 API 호출 시 — userId만 검증
  static void ensureUserId(String userId) {
    final message = validateUserId(userId);
    if (message != null) {
      throw FormatException(message);
    }
  }

  /// API 호출 전 검증. [isPasswordHashed]가 true이면 비밀번호 길이 규칙은 생략
  static void ensureAuthenticatedRequest({
    required String userId,
    required String userPw,
    bool isPasswordHashed = false,
  }) {
    ensureUserId(userId);
    if (isPasswordHashed) {
      if (userPw.length < clientHashMinLength ||
          userPw.length > clientHashMaxLength ||
          !_clientHashPattern.hasMatch(userPw)) {
        throw FormatException('저장된 비밀번호 형식이 올바르지 않습니다');
      }
    } else {
      final pwError = validateUserPw(userPw);
      if (pwError != null) {
        throw FormatException(pwError);
      }
    }
  }
}
