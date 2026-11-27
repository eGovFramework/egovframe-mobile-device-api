import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 앱 셸 하단 탭 (주요기능 · 기능설명 · 라이선스 · 더보기)
enum ShellTab { mainFunction, guide, license, more }

/// 앱 셸 하단 내비게이션 — 동일 너비 4탭, 아이콘+레이블, 상단 인디케이터
class AppShellTabBar extends StatelessWidget {
  final ShellTab selectedTab;
  final VoidCallback onMainFunctionTap;
  final VoidCallback onGuideTap;
  final VoidCallback onLicenseTap;
  final VoidCallback onMoreTap;

  const AppShellTabBar({
    super.key,
    required this.selectedTab,
    required this.onMainFunctionTap,
    required this.onGuideTap,
    required this.onLicenseTap,
    required this.onMoreTap,
  });

  static const double _tabHeight = 56;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Semantics(
      container: true,
      label: l10n.commonBottomTabNavigation,
      child: Material(
        color: EgovColor.white100,
        elevation: 8,
        shadowColor: EgovColor.black25,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: EgovColor.gray20, width: 1)),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 0),
            child: SizedBox(
              height: _tabHeight,
              child: Row(
                children: [
                  Expanded(
                    child: _ShellTabItem(
                      label: l10n.commonTabMainFunction,
                      outlinedIcon: Icons.smartphone_outlined,
                      filledIcon: Icons.smartphone,
                      isSelected: selectedTab == ShellTab.mainFunction,
                      onTap: onMainFunctionTap,
                    ),
                  ),
                  Expanded(
                    child: _ShellTabItem(
                      label: l10n.commonTabGuide,
                      outlinedIcon: Icons.menu_book_outlined,
                      filledIcon: Icons.menu_book,
                      isSelected: selectedTab == ShellTab.guide,
                      onTap: onGuideTap,
                    ),
                  ),
                  Expanded(
                    child: _ShellTabItem(
                      label: l10n.commonTabLicense,
                      outlinedIcon: Icons.gavel_outlined,
                      filledIcon: Icons.gavel,
                      isSelected: selectedTab == ShellTab.license,
                      onTap: onLicenseTap,
                    ),
                  ),
                  Expanded(
                    child: _ShellTabItem(
                      label: l10n.commonTabMore,
                      outlinedIcon: Icons.apps_outlined,
                      filledIcon: Icons.apps,
                      isSelected: selectedTab == ShellTab.more,
                      onTap: onMoreTap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellTabItem extends StatelessWidget {
  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShellTabItem({
    required this.label,
    required this.outlinedIcon,
    required this.filledIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? EgovColor.primary50 : EgovColor.gray60;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                color: isSelected ? EgovColor.primary50 : Colors.transparent,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? filledIcon : outlinedIcon,
                      size: 22,
                      color: color,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: EgovText.caption.copyWith(
                        color: color,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
