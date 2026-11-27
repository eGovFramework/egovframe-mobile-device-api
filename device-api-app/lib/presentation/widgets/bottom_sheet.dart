import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// 바텀시트 닫기 버튼 — 취소와 동일하게 동작
class _BottomSheetCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BottomSheetCloseButton({required this.onPressed});

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

/// 바텀시트 액션 항목
class AppBottomSheetAction {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const AppBottomSheetAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.iconColor,
  });
}

/// 바텀시트(핸들·헤더·본문·푸터) 구조
class AppBottomSheet extends StatelessWidget {
  final String title;
  final String? message;
  final List<AppBottomSheetAction>? actions;
  final Widget? child;
  final bool showFooterClose;

  /// 시스템 네비게이션 바 위에 추가로 둘 여백
  static const double _extraBottomSpace = 24;

  AppBottomSheet({
    super.key,
    required this.title,
    this.message,
    this.actions,
    this.child,
    this.showFooterClose = true,
  }) : assert(
         child != null || (actions != null && actions.isNotEmpty),
         'child 또는 actions 중 하나는 필요합니다.',
       );

  void _close(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // edge-to-edge에서는 padding.bottom이 0인 경우가 많아 viewPadding을 사용
    final systemBottom = MediaQuery.viewPaddingOf(context).bottom;
    final bottomSpace = systemBottom + _extraBottomSpace;

    return Container(
      decoration: const BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          top: BorderSide(color: EgovColor.gray20),
          left: BorderSide(color: EgovColor.gray20),
          right: BorderSide(color: EgovColor.gray20),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: EgovColor.gray30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 48, 0),
                child: Text(
                  title,
                  style: EgovText.title.copyWith(fontSize: 22, height: 1.5),
                ),
              ),
              Positioned(
                top: 8,
                right: 12,
                child: _BottomSheetCloseButton(
                  onPressed: () => _close(context),
                ),
              ),
            ],
          ),
          if (message != null && message!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                message!,
                style: EgovText.buttonText.copyWith(
                  color: EgovColor.gray90,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
            ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...List.generate(actions!.length, (index) {
              final action = actions![index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (index > 0)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: EgovColor.gray10,
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).maybePop();
                      action.onTap();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          if (action.icon != null) ...[
                            Icon(
                              action.icon,
                              size: 24,
                              color: action.iconColor ?? EgovColor.primary50,
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Text(
                              action.label,
                              style: EgovText.buttonText.copyWith(
                                color: EgovColor.gray90,
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ] else if (child != null) ...[
            const SizedBox(height: 12),
            child!,
          ],
          if (showFooterClose) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(width: 1, color: EgovColor.gray60),
                  foregroundColor: EgovColor.gray90,
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
                onPressed: () => _close(context),
                child: Text(l10n.commonClose),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 바텀시트를 띄우는 헬퍼
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required String title,
  String? message,
  List<AppBottomSheetAction>? actions,
  Widget? child,
  bool showFooterClose = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: EgovColor.black50,
    isDismissible: true,
    enableDrag: true,
    // 시트 내부에서 viewPadding으로 직접 처리하므로 이중 패딩 방지
    useSafeArea: false,
    builder: (_) => AppBottomSheet(
      title: title,
      message: message,
      actions: actions,
      showFooterClose: showFooterClose,
      child: child,
    ),
  );
}

/// 액션 목록형 바텀시트
Future<void> showAppActionSheet(
  BuildContext context, {
  required String title,
  String? message,
  required List<AppBottomSheetAction> actions,
  bool showFooterClose = true,
}) {
  return showAppBottomSheet(
    context,
    title: title,
    message: message,
    actions: actions,
    showFooterClose: showFooterClose,
  );
}
