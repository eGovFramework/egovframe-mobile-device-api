import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:flutter/material.dart';

class ServerConnectionUtils {
  static final NetworkService _networkService = NetworkService();

  static Future<bool> checkConnectionAndExecute({
    required BuildContext context,
    required Future<void> Function() operation,
    bool showToastOnFailure = true,
  }) async {
    try {
      final isConnected = await _networkService.isServerConnected();

      if (!isConnected) {
        if (showToastOnFailure && context.mounted) {
          _showConnectionErrorToast(context);
        }
        return false;
      }

      await operation();
      return true;
    } catch (e) {
      appLog('서버 연결 확인 및 작업 실행 오류: $e');
      if (showToastOnFailure && context.mounted) {
        _showConnectionErrorToast(context);
      }
      return false;
    }
  }

  static Future<bool> checkConnectionAndExecuteIfConnected({
    required BuildContext context,
    required Future<void> Function() operation,
  }) async {
    return checkConnectionAndExecute(
      context: context,
      operation: operation,
      showToastOnFailure: true,
    );
  }

  static Future<bool> checkConnectionAndShowToast({
    required BuildContext context,
  }) async {
    try {
      final isConnected = await _networkService.isServerConnected();

      if (!isConnected) {
        if (context.mounted) {
          _showConnectionErrorToast(context);
        }
        return false;
      }

      return true;
    } catch (e) {
      appLog('서버 연결 확인 오류: $e');
      if (context.mounted) {
        _showConnectionErrorToast(context);
      }
      return false;
    }
  }

  static void _showConnectionErrorToast(BuildContext context) {
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    showStatusToast(
      context,
      variant: StatusVariant.error,
      title: l10n.serverConnectionErrorTitle,
      message: l10n.serverConnectionErrorMessage,
    );
  }
}
