import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:flutter/material.dart';

enum ErrorType {
  network,
  permission,
  location,
  camera,
  storage,
  file,
  unknown,
}

/// 에러 처리를 위한 유틸리티 클래스
class ErrorHandler {

  static String getErrorMessage(dynamic error, ErrorType type) {
    final errorString = error.toString().toLowerCase();
    
    switch (type) {
      case ErrorType.network:
        if (errorString.contains('timeout')) {
          return '네트워크 연결 시간이 초과되었습니다. 인터넷 연결을 확인해주세요.';
        } else if (errorString.contains('connection')) {
          return '네트워크 연결에 실패했습니다. 인터넷 연결을 확인해주세요.';
        } else if (errorString.contains('404')) {
          return '요청한 서비스를 찾을 수 없습니다.';
        } else if (errorString.contains('500')) {
          return '서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
        } else {
          return '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.';
        }
        
      case ErrorType.permission:
        if (errorString.contains('denied')) {
          return '권한이 거부되었습니다. 설정에서 권한을 허용해주세요.';
        } else if (errorString.contains('permanently')) {
          return '권한이 영구적으로 거부되었습니다. 앱 설정에서 직접 권한을 허용해주세요.';
        } else {
          return '권한 오류가 발생했습니다. 설정에서 권한을 확인해주세요.';
        }
        
      case ErrorType.location:
        if (errorString.contains('service')) {
          return '위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 활성화해주세요.';
        } else if (errorString.contains('timeout')) {
          return '위치 정보를 가져오는 시간이 초과되었습니다. 다시 시도해주세요.';
        } else if (errorString.contains('accuracy')) {
          return '위치 정확도가 부족합니다. 더 넓은 공간에서 다시 시도해주세요.';
        } else {
          return '위치 정보를 가져올 수 없습니다. GPS 설정을 확인해주세요.';
        }
        
      case ErrorType.camera:
        if (errorString.contains('permission')) {
          return '카메라 권한이 필요합니다. 설정에서 카메라 권한을 허용해주세요.';
        } else if (errorString.contains('not available')) {
          return '카메라를 사용할 수 없습니다. 다른 앱에서 카메라를 사용 중인지 확인해주세요.';
        } else {
          return '카메라 오류가 발생했습니다. 카메라를 다시 시도해주세요.';
        }
        
      case ErrorType.storage:
        if (errorString.contains('permission')) {
          return '저장소 권한이 필요합니다. 설정에서 저장소 권한을 허용해주세요.';
        } else if (errorString.contains('full')) {
          return '저장 공간이 부족합니다. 일부 파일을 삭제한 후 다시 시도해주세요.';
        } else if (errorString.contains('not found')) {
          return '파일을 찾을 수 없습니다.';
        } else {
          return '저장소 오류가 발생했습니다. 저장 공간을 확인해주세요.';
        }
        
      case ErrorType.file:
        if (errorString.contains('not found')) {
          return '파일을 찾을 수 없습니다.';
        } else if (errorString.contains('corrupted')) {
          return '파일이 손상되었습니다. 다른 파일을 선택해주세요.';
        } else if (errorString.contains('too large')) {
          return '파일 크기가 너무 큽니다. 더 작은 파일을 선택해주세요.';
        } else {
          return '파일 처리 중 오류가 발생했습니다.';
        }
        
      case ErrorType.unknown:
      default:
        return '알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }
  }

  /// 에러 타입 자동 감지
  static ErrorType detectErrorType(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || 
        errorString.contains('connection') || 
        errorString.contains('timeout') ||
        errorString.contains('http')) {
      return ErrorType.network;
    } else if (errorString.contains('permission') || 
               errorString.contains('denied')) {
      return ErrorType.permission;
    } else if (errorString.contains('location') || 
               errorString.contains('gps') ||
               errorString.contains('service')) {
      return ErrorType.location;
    } else if (errorString.contains('camera')) {
      return ErrorType.camera;
    } else if (errorString.contains('storage') || 
               errorString.contains('file') ||
               errorString.contains('directory')) {
      return ErrorType.storage;
    } else if (errorString.contains('corrupted') || 
               errorString.contains('not found') ||
               errorString.contains('too large')) {
      return ErrorType.file;
    } else {
      return ErrorType.unknown;
    }
  }

  /// 에러 다이얼로그 표시
  static Future<void> showErrorDialog(
    BuildContext context, 
    String message, {
    String? title,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    return showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: title ?? '오류',
      message: message,
    );
  }

  /// 성공 다이얼로그 표시
  static Future<void> showSuccessDialog(
    BuildContext context, 
    String message, {
    String? title,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: EgovColor.white100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: EgovColor.success50,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title ?? '성공',
                style: EgovText.title.copyWith(
                  color: EgovColor.success60,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: EgovText.regular,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '확인',
                style: EgovText.regular.copyWith(
                  color: EgovColor.primary50,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 에러 다이얼로그 표시 (showStatusDialog 사용)
  static void showErrorSnackBar(
    BuildContext context, 
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: '오류',
      message: message,
    );
  }

  /// 성공 다이얼로그 표시 (showStatusDialog 사용)
  static void showSuccessSnackBar(
    BuildContext context, 
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showStatusDialog(
      context,
      variant: StatusVariant.success,
      title: '성공',
      message: message,
    );
  }

  /// 에러 로깅
  static void logError(dynamic error, StackTrace? stackTrace, {String? context}) {
    print('=== ERROR LOG ===');
    if (context != null) {
      print('Context: $context');
    }
    print('Error: $error');
    if (stackTrace != null) {
      print('Stack Trace: $stackTrace');
    }
    print('================');
  }
}
