import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';

import '../screens/application_list_main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;
  final bool hideHomeButton; // Home 버튼을 숨길지 여부 (기본값: false, 즉 항상 표시)

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.hideHomeButton = false, // 기본값은 false (표시)
  });

  /// 현재 화면이 메인 화면(ApplicationListMain)인지 동적으로 확인
  bool _isMainScreen(BuildContext context) {
    // 방법 1: 위젯 트리에서 ApplicationListMain 찾기 (가장 확실한 방법)
    final mainScreen = context
        .findAncestorWidgetOfExactType<ApplicationListMain>();
    if (mainScreen != null) { 
      return true;
    }

    // 방법 2: Navigator.canPop() 확인 (뒤로 갈 수 없으면 메인 화면)
    final canPop = Navigator.of(context).canPop();
    if (!canPop) {
      return true; // 뒤로 갈 수 없으면 메인 화면
    }

    // 방법 3: 현재 라우트의 위젯 타입 확인
    final route = ModalRoute.of(context);
    if (route != null && route.settings.arguments != null) {
      // 라우트 인자로 전달된 위젯 타입 확인 (선택사항)
    }

    return false; // 기본적으로 서브 화면으로 간주
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> finalActions = [];

    // Home 버튼 자동 표시: 메인 화면이 아니고 hideHomeButton이 false일 때만 표시
    if (!hideHomeButton) {
      // 동적으로 메인 화면 감지 (ApplicationListMain 위젯 타입으로만 확인)
      final mainScreen = context
          .findAncestorWidgetOfExactType<ApplicationListMain>();
      final isMainScreen = mainScreen != null;

      // ApplicationListMain이 아닌 모든 화면에서 Home 버튼 표시
      // 로그아웃 후에도 Home 버튼이 표시되도록 함
      if (!isMainScreen) {
        finalActions.add(
          IconButton(
            icon: const Icon(Icons.home, color: EgovColor.white100),
            tooltip: '홈으로 이동',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const ApplicationListMain(
                    title: 'Mobile Application List',
                  ),
                ),
                (route) => false, // 모든 이전 라우트 제거
              );
            },
          ),
        );
      }
    }

    // 기존 actions가 있으면 추가
    if (actions != null) {
      finalActions.addAll(actions!);
    }

    return AppBar(
      backgroundColor: EgovColor.primary50,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: finalActions.isNotEmpty ? finalActions : null,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: EgovColor.white100,
          fontWeight: FontWeight.bold,
          fontFamily: "Pretendard GOV",
        ),
      ),
      centerTitle: true,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    if (bottom != null) {
      return Size.fromHeight(kToolbarHeight + bottom!.preferredSize.height);
    }
    return const Size.fromHeight(kToolbarHeight);
  }
}
