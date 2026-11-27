import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/app_shell_tab_bar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:flutter/material.dart';

class ApiFeatureShell extends StatelessWidget {
  final ApiFeature feature;
  final String title;
  final Widget mainFunctionBody;
  final Widget? bottomBar;
  final FeatureShellController? controller;
  final PreferredSizeWidget Function(FeatureShellController controller)?
  appBarBuilder;
  final bool Function(ShellTab shellTab)? onBeforeBack;
  final int popToApiMainCount;

  const ApiFeatureShell({
    super.key,
    required this.feature,
    required this.title,
    required this.mainFunctionBody,
    this.bottomBar,
    this.controller,
    this.appBarBuilder,
    this.onBeforeBack,
    this.popToApiMainCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final config = ApiFeatureShellConfig.of(feature);

    return FeatureShell(
      title: title,
      currentAppTargetPage: config.targetPage,
      guidePage: config.guidePage,
      mainFunctionBody: mainFunctionBody,
      bottomBar: bottomBar,
      controller: controller,
      appBarBuilder: appBarBuilder,
      onBeforeBack: onBeforeBack,
      popToApiMainCount: popToApiMainCount,
    );
  }
}
