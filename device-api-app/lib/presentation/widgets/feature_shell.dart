import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/app_navigation_hub.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/app_shell_tab_bar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:flutter/material.dart';

/// [FeatureShell] 내부 내비게이션을 부모 AppBar 등에서 사용하기 위한 컨트롤러
class FeatureShellController {
  VoidCallback? _handleBack;
  VoidCallback? _openGuidePage;
  VoidCallback? _openMainFunctionPage;

  void _bind({
    required VoidCallback handleBack,
    required VoidCallback openGuidePage,
    required VoidCallback openMainFunctionPage,
  }) {
    _handleBack = handleBack;
    _openGuidePage = openGuidePage;
    _openMainFunctionPage = openMainFunctionPage;
  }

  void handleBack() => _handleBack?.call();
  void openGuidePage() => _openGuidePage?.call();
  void openMainFunctionTab() => _openMainFunctionPage?.call();
}

/// 앱 셸 — 하단 4탭(주요기능·기능설명·라이선스·더보기)
class FeatureShell extends StatefulWidget {
  final String title;
  final String currentAppTargetPage;
  final Widget guidePage;
  final Widget mainFunctionBody;
  final Widget? bottomBar;
  final FeatureShellController? controller;
  final PreferredSizeWidget Function(FeatureShellController controller)?
  appBarBuilder;
  final bool Function(ShellTab shellTab)? onBeforeBack;

  /// 주요기능 탭이 이미 선택된 상태에서 다시 누를 때 API 메인까지 pop할 횟수
  /// (목록=1, 상세=2, 메인=0)
  final int popToApiMainCount;

  const FeatureShell({
    super.key,
    required this.title,
    required this.currentAppTargetPage,
    required this.guidePage,
    required this.mainFunctionBody,
    this.bottomBar,
    this.controller,
    this.appBarBuilder,
    this.onBeforeBack,
    this.popToApiMainCount = 0,
  });

  @override
  State<FeatureShell> createState() => _FeatureShellState();
}

class _FeatureShellState extends State<FeatureShell> {
  late final FeatureShellController _shellController;
  ShellTab _shellTab = ShellTab.mainFunction;

  @override
  void initState() {
    super.initState();
    _shellController = widget.controller ?? FeatureShellController();
    _shellController._bind(
      handleBack: _handleBackNavigation,
      openGuidePage: () => _selectTab(ShellTab.guide),
      openMainFunctionPage: _handleMainFunctionTap,
    );
  }

  void _selectTab(ShellTab tab) {
    setState(() => _shellTab = tab);
  }

  void _handleMainFunctionTap() {
    if (_shellTab != ShellTab.mainFunction) {
      _selectTab(ShellTab.mainFunction);
      return;
    }
    if (widget.popToApiMainCount <= 0) return;

    var remaining = widget.popToApiMainCount;
    while (remaining > 0 && Navigator.canPop(context)) {
      Navigator.pop(context);
      remaining--;
    }
  }

  void _handleBackNavigation() {
    if (widget.onBeforeBack?.call(_shellTab) == true) {
      return;
    }
    if (_shellTab != ShellTab.mainFunction) {
      _selectTab(ShellTab.mainFunction);
      return;
    }
    Navigator.pop(context);
  }

  bool get _canPopRoute => _shellTab == ShellTab.mainFunction;

  PreferredSizeWidget _buildDefaultAppBar() {
    return CustomAppBar(
      title: widget.title,
      hideHomeButton: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
        onPressed: _handleBackNavigation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = widget.appBarBuilder != null
        ? widget.appBarBuilder!(_shellController)
        : _buildDefaultAppBar();

    return PopScope(
      canPop: _canPopRoute,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBackNavigation();
      },
      child: Scaffold(
        backgroundColor: EgovColor.white100,
        extendBodyBehindAppBar: false,
        appBar: appBar,
        body: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: switch (_shellTab) {
                ShellTab.mainFunction => widget.mainFunctionBody,
                ShellTab.guide => widget.guidePage,
                ShellTab.license => const License(),
                ShellTab.more => AppNavigationHub(
                  currentTargetPage: widget.currentAppTargetPage,
                ),
              },
            ),
            if (_shellTab == ShellTab.mainFunction && widget.bottomBar != null)
              widget.bottomBar!,
          ],
        ),
        bottomNavigationBar: AppShellTabBar(
          selectedTab: _shellTab,
          onMainFunctionTap: _handleMainFunctionTap,
          onGuideTap: () => _selectTab(ShellTab.guide),
          onLicenseTap: () => _selectTab(ShellTab.license),
          onMoreTap: () => _selectTab(ShellTab.more),
        ),
      ),
    );
  }
}
