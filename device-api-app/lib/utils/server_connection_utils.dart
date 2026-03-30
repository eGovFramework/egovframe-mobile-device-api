import 'package:egovframe_mobile_deviceapi_app/data/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:flutter/material.dart';

class ServerConnectionUtils {
  static final NetworkService _networkService = NetworkService();

  static Future<bool> checkConnectionAndExecute({
    required BuildContext context,
    required Future<void> Function() operation,
    String errorTitle = '서버 연결 오류',
    String errorMessage = '서버에 연결할 수 없습니다. 네트워크 연결을 확인하고 다시 시도해주세요.',
    bool showToastOnFailure = true,
  }) async {
    try {
      // 서버 연결 상태 확인
      final isConnected = await _networkService.isServerConnected();
      
      if (!isConnected) {
        if (showToastOnFailure) {
          _showConnectionErrorToast(
            context,
            errorTitle: errorTitle,
            errorMessage: errorMessage,
          );
        }
        return false;
      }
      
      // 서버에 연결되어 있으면 작업 실행
      await operation();
      return true;
    } catch (e) {
      debugPrint('서버 연결 확인 및 작업 실행 오류: $e');
      if (showToastOnFailure) {
        _showConnectionErrorToast(
          context,
          errorTitle: errorTitle,
          errorMessage: errorMessage,
        );
      }
      return false;
    }
  }

  /// 서버 연결을 확인하고 성공 시에만 작업을 실행하는 메서드
  /// 
  /// [context] - BuildContext
  /// [operation] - 서버 연결이 성공했을 때 실행할 작업
  /// [errorTitle] - 연결 실패 시 토스트 제목
  /// [errorMessage] - 연결 실패 시 토스트 메시지
  /// 
  /// Returns: 서버 연결 성공 여부
  static Future<bool> checkConnectionAndExecuteIfConnected({
    required BuildContext context,
    required Future<void> Function() operation,
    String errorTitle = '서버 연결 오류',
    String errorMessage = '서버에 연결할 수 없습니다. 네트워크 연결을 확인하고 다시 시도해주세요.',
  }) async {
    return await checkConnectionAndExecute(
      context: context,
      operation: operation,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      showToastOnFailure: true,
    );
  }

  /// 서버 연결을 확인하고 실패 시 토스트만 표시하는 메서드
  /// 
  /// [context] - BuildContext
  /// [errorTitle] - 연결 실패 시 토스트 제목
  /// [errorMessage] - 연결 실패 시 토스트 메시지
  /// 
  /// Returns: 서버 연결 성공 여부
  static Future<bool> checkConnectionAndShowToast({
    required BuildContext context,
    String errorTitle = '서버 연결 오류',
    String errorMessage = '서버에 연결할 수 없습니다. 네트워크 연결을 확인하고 다시 시도해주세요.',
  }) async {
    try {
      final isConnected = await _networkService.isServerConnected();
      
      if (!isConnected) {
        _showConnectionErrorToast(
          context,
          errorTitle: errorTitle,
          errorMessage: errorMessage,
        );
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('서버 연결 확인 오류: $e');
      _showConnectionErrorToast(
        context,
        errorTitle: errorTitle,
        errorMessage: errorMessage,
      );
      return false;
    }
  }

  /// 연결 오류 다이얼로그 표시
  static void _showConnectionErrorToast(
    BuildContext context, {
    required String errorTitle,
    required String errorMessage,
  }) {
    showStatusDialog(
      context,
      variant: StatusVariant.error,
      title: errorTitle,
      message: errorMessage,
    );
  }
}
