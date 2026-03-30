import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// 상태 타입
enum StatusVariant { success, error }

/// HTML prompt처럼 제목/본문/확인/취소를 전달받아 표시하는 다이얼로그
class PromptDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const PromptDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = '확인',
    this.cancelText = '취소',
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(12);

    return AlertDialog(
      backgroundColor: EgovColor.white100,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(width: 1, color: EgovColor.gray20),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 160, maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: EgovText.title.copyWith(
                fontSize: 22,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message,
              style: EgovText.buttonText.copyWith(
                color: EgovColor.gray90,
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // 취소
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1, color: EgovColor.gray60),
            foregroundColor: EgovColor.gray90,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            textStyle: const TextStyle(
              fontSize: 17,
              fontFamily: 'Pretendard GOV',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          onPressed: () {
            Navigator.of(context).maybePop(false);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        // 확인
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: EgovColor.primary50,
            foregroundColor: EgovColor.white100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            textStyle: const TextStyle(
              fontSize: 17,
              fontFamily: 'Pretendard GOV',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          onPressed: () {
            Navigator.of(context).maybePop(true);
            onConfirm?.call();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// 성공/오류 상태 알림 박스 (업로드 성공/삭제 실패 등)
class StatusAlert extends StatelessWidget {
  final StatusVariant variant;
  final String title;
  final String message;

  const StatusAlert({
    super.key,
    required this.variant,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = variant == StatusVariant.success;

    final Color textColor = isSuccess ? const Color(0xFF267337) : const Color(0xFFBD2C0F);
    final String iconAsset = isSuccess
        ? 'assets/images/icons/system-success.png'
        : 'assets/images/icons/system-error.png';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left status icon (PNG)
              SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  iconAsset,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontFamily: 'Pretendard GOV',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontFamily: 'Pretendard GOV',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// PromptDialog를 쉽게 띄우는 헬퍼. true(확인), false(취소)
Future<bool?> showPromptDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = '확인',
  String cancelText = '취소',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PromptDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}

/// 메시지를 간단한 형식으로 변환
/// '<기능>가 성공적으로 완료되었습니다' -> '<기능> 완료 성공'
/// '<기능>가 성공적으로 저장되었습니다' -> '<기능> 저장 성공'
/// '<기능> 저장에 실패했습니다' -> '<기능> 저장 실패'
String _simplifyMessage(String message, StatusVariant variant) {
  // 성공 메시지 패턴: '<기능>가 성공적으로 (완료|저장|업로드|삭제|생성|수정)되었습니다'
  final successPattern = RegExp(r'^(.+?)(가|이) 성공적으로 (완료|저장|업로드|삭제|생성|수정)되었습니다\.?$');
  if (variant == StatusVariant.success && successPattern.hasMatch(message)) {
    final match = successPattern.firstMatch(message);
    if (match != null) {
      final feature = match.group(1)?.trim() ?? '';
      final action = match.group(3) ?? '저장';
      return '$feature $action 성공';
    }
  }
  
  // 실패 메시지 패턴: '<기능> (저장|업로드|삭제|생성|수정)에 실패했습니다' 또는 '<기능> (저장|업로드|삭제|생성|수정) 중 오류가 발생했습니다'
  final failPattern1 = RegExp(r'^(.+?)(가|이) (저장|업로드|삭제|생성|수정)에 실패했습니다\.?$');
  final failPattern2 = RegExp(r'^(.+?)(가|이) (저장|업로드|삭제|생성|수정) 중 오류가 발생했습니다\.?.*$');
  if (variant == StatusVariant.error) {
    if (failPattern1.hasMatch(message)) {
      final match = failPattern1.firstMatch(message);
      if (match != null) {
        final feature = match.group(1)?.trim() ?? '';
        final action = match.group(3) ?? '저장';
        return '$feature $action 실패';
      }
    } else if (failPattern2.hasMatch(message)) {
      final match = failPattern2.firstMatch(message);
      if (match != null) {
        final feature = match.group(1)?.trim() ?? '';
        final action = match.group(3) ?? '저장';
        return '$feature $action 실패';
      }
    }
  }
  
  return message;
}

/// StatusAlert를 다이얼로그로 보여주는 헬퍼
Future<void> showStatusDialog(
  BuildContext context, {
  required StatusVariant variant,
  required String title,
  required String message,
  String closeText = '닫기',
  VoidCallback? onRetry,
  String? retryText,
}) {
  final bool isSuccess = variant == StatusVariant.success;
  final Color bgColor =
      isSuccess ? EgovColor.success5 : EgovColor.danger5;
  final Color borderColor =
      isSuccess ? EgovColor.success10 : EgovColor.danger10;
  final Color textColor =
      isSuccess ? EgovColor.success60 : EgovColor.danger60;
  
  // 메시지를 간단한 형식으로 변환
  final simplifiedMessage = _simplifyMessage(message, variant);

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      backgroundColor: bgColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: 1, color: borderColor),
      ),
      contentPadding: EdgeInsets.zero,
      actionsPadding: onRetry != null
          ? const EdgeInsets.fromLTRB(0, 0, 16, 12)
          : EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: StatusAlert(
                variant: variant,
                title: title,
                message: simplifiedMessage,
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: textColor,
                  size: 24,
                ),
                onPressed: () => Navigator.of(ctx).maybePop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
      actions: onRetry != null
          ? [
              TextButton(
                onPressed: () => Navigator.of(ctx).maybePop(),
                child: Text(
                  closeText,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'Pretendard GOV',
                    fontSize: 15,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).maybePop();
                  onRetry();
                },
                child: Text(
                  retryText ?? '다시 시도',
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'Pretendard GOV',
                    fontSize: 15,
                  ),
                ),
              ),
            ]
          : null,
    ),
  );
}

