import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 상태 타입 (toast 등에서 사용)
enum StatusVariant { success, error }

/// 모달 닫기 버튼 — 취소와 동일하게 동작
class _ModalCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ModalCloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      icon: const Icon(Icons.close, color: EgovColor.gray90, size: 24),
      tooltip: l10n.commonClose,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    );
  }
}

/// 모달 구조(헤더·본문·푸터) 기반 확인/취소 다이얼로그
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
    this.confirmText = '',
    this.cancelText = '',
    this.onConfirm,
    this.onCancel,
  });

  void _dismiss(BuildContext context, {required bool confirmed}) {
    Navigator.of(context).maybePop(confirmed);
    if (confirmed) {
      onConfirm?.call();
    } else {
      onCancel?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final confirmLabel = confirmText.isEmpty ? l10n.commonConfirm : confirmText;
    final cancelLabel = cancelText.isEmpty ? l10n.commonCancel : cancelText;
    return Dialog(
      backgroundColor: EgovColor.white100,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(width: 1, color: EgovColor.gray20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 48, 0),
                  child: Text(
                    title,
                    style: EgovText.title.copyWith(fontSize: 22, height: 1.5),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _ModalCloseButton(
                    onPressed: () => _dismiss(context, confirmed: false),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Text(
                message,
                style: EgovText.buttonText.copyWith(
                  color: EgovColor.gray90,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1, color: EgovColor.gray60),
                      foregroundColor: EgovColor.gray90,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Pretendard GOV',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    onPressed: () => _dismiss(context, confirmed: false),
                    child: Text(cancelLabel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EgovColor.primary50,
                      foregroundColor: EgovColor.white100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Pretendard GOV',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    onPressed: () => _dismiss(context, confirmed: true),
                    child: Text(confirmLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PromptDialog를 쉽게 띄우는 헬퍼. true(확인), false(취소)
Future<bool?> showPromptDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = '',
  String cancelText = '',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: EgovColor.black50,
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

/// 서버 등록 확인. true이면 등록 진행
Future<bool> showServerRegisterConfirm(
  BuildContext context, {
  required String message,
  String title = '',
  String confirmText = '',
  String cancelText = '',
}) async {
  final l10n = AppLocalizations.of(context)!;
  final bool? result = await showPromptDialog(
    context,
    title: title.isEmpty ? l10n.commonRegisterConfirmTitle : title,
    message: message,
    confirmText: confirmText.isEmpty ? l10n.commonRegister : confirmText,
    cancelText: cancelText.isEmpty ? l10n.commonCancel : cancelText,
  );
  return result == true;
}

/// 서버 삭제 확인. true이면 삭제 진행
Future<bool> showServerDeleteConfirm(
  BuildContext context, {
  required String message,
  String title = '',
  String confirmText = '',
  String cancelText = '',
}) async {
  final l10n = AppLocalizations.of(context)!;
  final bool? result = await showPromptDialog(
    context,
    title: title.isEmpty ? l10n.commonDeleteConfirmTitle : title,
    message: message,
    confirmText: confirmText.isEmpty ? l10n.commonDelete : confirmText,
    cancelText: cancelText.isEmpty ? l10n.commonCancel : cancelText,
  );
  return result == true;
}

/// 메시지를 토스트용 한 줄 형식으로 변환
String simplifyStatusMessage(
  String message,
  StatusVariant variant,
  AppLocalizations l10n,
) {
  final RegExp successPattern = RegExp(
    r'^(.+?)(가|이) 성공적으로 (완료|저장|업로드|삭제|생성|수정)되었습니다\.?$',
  );
  if (variant == StatusVariant.success && successPattern.hasMatch(message)) {
    final RegExpMatch? match = successPattern.firstMatch(message);
    if (match != null) {
      final String feature = match.group(1)?.trim() ?? '';
      final String action = _toastActionLabel(l10n, match.group(3));
      return l10n.commonToastFeatureActionSuccess(feature, action);
    }
  }

  final RegExp failPattern1 = RegExp(
    r'^(.+?)(가|이) (저장|업로드|삭제|생성|수정)에 실패했습니다\.?$',
  );
  final RegExp failPattern2 = RegExp(
    r'^(.+?)(가|이) (저장|업로드|삭제|생성|수정) 중 오류가 발생했습니다\.?.*$',
  );
  if (variant == StatusVariant.error) {
    if (failPattern1.hasMatch(message)) {
      final RegExpMatch? match = failPattern1.firstMatch(message);
      if (match != null) {
        final String feature = match.group(1)?.trim() ?? '';
        final String action = _toastActionLabel(l10n, match.group(3));
        return l10n.commonToastFeatureActionFailure(feature, action);
      }
    } else if (failPattern2.hasMatch(message)) {
      final RegExpMatch? match = failPattern2.firstMatch(message);
      if (match != null) {
        final String feature = match.group(1)?.trim() ?? '';
        final String action = _toastActionLabel(l10n, match.group(3));
        return l10n.commonToastFeatureActionFailure(feature, action);
      }
    }
  }

  return message;
}

/// Validation 등 단순 안내 알림 (기본: 확인·취소, showCancel=false면 확인만)
Future<void> showInfoAlert(
  BuildContext context, {
  required String message,
  String title = '',
  String confirmText = '',
  bool showCancel = true,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmLabel = confirmText.isEmpty ? l10n.commonConfirm : confirmText;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: EgovColor.black50,
    builder: (dialogContext) => Dialog(
      backgroundColor: EgovColor.white100,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(width: 1, color: EgovColor.gray20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title.isEmpty ? l10n.commonRegisterConfirmTitle : title,
                style: EgovText.title.copyWith(fontSize: 22, height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: EgovText.regular.copyWith(
                  color: EgovColor.gray70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showCancel) ...[
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(l10n.commonCancel),
                    ),
                    const SizedBox(width: 8),
                  ],
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(confirmLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String _toastActionLabel(AppLocalizations l10n, String? action) {
  return switch (action) {
    '업로드' => l10n.commonActionUpload,
    '삭제' => l10n.commonActionDelete,
    '생성' => l10n.commonActionCreate,
    '수정' => l10n.commonActionModify,
    '완료' => l10n.commonActionComplete,
    _ => l10n.commonActionSave,
  };
}
