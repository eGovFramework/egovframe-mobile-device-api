import '../../utils/format_utils.dart';

class UserInfo {
  final String userId;
  final String userPw;
  final String emails;
  final String? deviceUuid;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  UserInfo({
    required this.userId,
    required this.userPw,
    required this.emails,
    this.deviceUuid,
    this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
  });

  /// JSON으로부터 UserInfo를 생성
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] ?? json['id'] ?? '',
      userPw: json['userPw'] ?? json['password'] ?? '',
      emails: json['emails'] ?? '',
      deviceUuid: json['deviceUuid'] ?? json['uuid'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userPw': userPw,
      'emails': emails,
      'deviceUuid': deviceUuid,
      'uuid': deviceUuid, // 서버와의 호환성을 위해 uuid도 포함
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// 생성일을 포맷된 문자열로 반환
  String get formattedCreatedAt => createdAt != null ? FormatUtils.formatDateTime(createdAt!) : 'N/A';

  /// 마지막 로그인일을 포맷된 문자열로 반환
  String get formattedLastLoginAt => lastLoginAt != null ? FormatUtils.formatDateTime(lastLoginAt!) : 'N/A';

  /// 사용자 상태를 문자열로 반환
  String get statusText {
    return isActive ? '활성' : '비활성';
  }

  @override
  String toString() {
    return 'UserInfo(userId: $userId, emails: $emails, deviceUuid: $deviceUuid, isActive: $isActive)';
  }
}

/// 로그인 응답
class LoginResponse {
  final bool success;
  final String message;
  final UserInfo? userInfo;
  final String? token;
  final DateTime? loginTime;

  LoginResponse({
    required this.success,
    required this.message,
    this.userInfo,
    this.token,
    this.loginTime,
  });

  /// JSON으로부터 LoginResponse를 생성
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['msg'] ?? '',
      userInfo: json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
      token: json['token'],
      loginTime: json['loginTime'] != null ? DateTime.parse(json['loginTime']) : DateTime.now(),
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'userInfo': userInfo?.toJson(),
      'token': token,
      'loginTime': loginTime?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'LoginResponse(success: $success, message: $message, userInfo: $userInfo)';
  }
}

/// 회원가입 응답
class RegisterResponse {
  final bool success;
  final String message;
  final UserInfo? userInfo;

  RegisterResponse({
    required this.success,
    required this.message,
    this.userInfo,
  });

  /// JSON으로부터 RegisterResponse를 생성
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['msg'] ?? '',
      userInfo: json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'userInfo': userInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return 'RegisterResponse(success: $success, message: $message, userInfo: $userInfo)';
  }
}

/// 계정 존재 여부 확인 응답
class AccountCheckResponse {
  final bool exists;
  final String message;

  AccountCheckResponse({
    required this.exists,
    required this.message,
  });

  /// JSON으로부터 AccountCheckResponse를 생성
  factory AccountCheckResponse.fromJson(Map<String, dynamic> json) {
    return AccountCheckResponse(
      exists: json['exists'] ?? false,
      message: json['message'] ?? json['msg'] ?? '',
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'exists': exists,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'AccountCheckResponse(exists: $exists, message: $message)';
  }
}

/// 회원탈퇴 응답
class WithdrawResponse {
  final bool success;
  final String message;

  WithdrawResponse({
    required this.success,
    required this.message,
  });

  /// JSON으로부터 WithdrawResponse를 생성
  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['msg'] ?? '',
    );
  }

  /// JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'WithdrawResponse(success: $success, message: $message)';
  }
}
