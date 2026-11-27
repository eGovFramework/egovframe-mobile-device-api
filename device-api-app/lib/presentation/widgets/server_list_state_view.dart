import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 서버 목록 조회 시 데이터가 없을 때 표시하는 메시지
class ServerListEmptyMessage extends StatelessWidget {
  final String message;

  const ServerListEmptyMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: EgovText.regular.copyWith(color: EgovColor.gray40),
      ),
    );
  }
}

/// 서버 목록 조회 오류 시 표시
class ServerListErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ServerListErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: EgovColor.danger50),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: EgovText.regular.copyWith(color: EgovColor.danger50),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
