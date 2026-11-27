import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

/// 본문 영역을 줄이지 않도록 한 줄만 보여주고, 탭하면 연결 카드를 시트로 연다.
class FeatureConnectionBar extends StatelessWidget {
  const FeatureConnectionBar({
    super.key,
    required this.title,
    required this.detail,
    required this.statusColor,
    required this.hint,
    this.sheetChild,
    this.onBarTap,
    this.isConnected = false,
    this.backgroundColor = EgovColor.white100,
    this.borderColor = EgovColor.gray20,
    this.titleColor = EgovColor.gray90,
    this.detailColor = EgovColor.gray60,
    this.iconColor = EgovColor.gray60,
    this.showTrailingIcon = true,
    this.trailing,
  });

  final String title;
  final String detail;
  final Color statusColor;
  final Widget? sheetChild;
  final VoidCallback? onBarTap;
  final bool isConnected;
  final String hint;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color detailColor;
  final Color iconColor;
  final bool showTrailingIcon;
  final Widget? trailing;

  VoidCallback? _resolveBarTap(BuildContext context) {
    if (onBarTap != null) return onBarTap;
    if (sheetChild != null) return () => _openConnectionSheet(context);
    return null;
  }

  Widget? _resolveTrailing(BuildContext context) {
    if (trailing != null) return trailing;
    if (sheetChild == null) return null;

    final l10n = AppLocalizations.of(context)!;
    return FeatureConnectionActionButton(
      label: isConnected
          ? l10n.connectionBarChangeButton
          : l10n.connectionBarConnectButton,
      filled: !isConnected,
      onPressed: () => _openConnectionSheet(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barTap = _resolveBarTap(context);
    final action = _resolveTrailing(context);
    final statusContent = Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: EgovText.medium.copyWith(
                  color: titleColor,
                  fontSize: 13,
                ),
              ),
              Text(
                detail.isEmpty ? hint : detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: EgovText.caption.copyWith(
                  color: detailColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: borderColor),
    );

    if (action != null) {
      final status = Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: statusContent,
      );
      return Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          decoration: decoration,
          child: Row(
            children: [
              Expanded(
                child: barTap == null
                    ? status
                    : InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                        onTap: barTap,
                        child: status,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: action,
              ),
            ],
          ),
        ),
      );
    }

    final row = Row(
      children: [
        Expanded(child: statusContent),
        if (showTrailingIcon)
          Icon(
            Icons.tune,
            size: 18,
            color: iconColor,
          ),
      ],
    );

    final padded = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: decoration,
      child: row,
    );

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: barTap == null
          ? padded
          : InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: barTap,
              child: padded,
            ),
    );
  }

  Future<void> _openConnectionSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottom = MediaQuery.viewPaddingOf(sheetContext).bottom;
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
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: EgovColor.gray30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              sheetChild!,
            ],
          ),
        );
      },
    );
  }
}

/// MQTT·서버 연결 바 공통 액션 버튼.
class FeatureConnectionActionButton extends StatelessWidget {
  const FeatureConnectionActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: EgovColor.primary50,
            ),
          ),
        ),
      );
    }

    final foreground = filled ? EgovColor.white100 : EgovColor.primary50;
    final background = filled ? EgovColor.primary50 : EgovColor.white100;

    return SizedBox(
      height: 32,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: const BorderSide(color: EgovColor.primary50),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          minimumSize: const Size(52, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          label,
          style: EgovText.medium.copyWith(
            color: foreground,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
