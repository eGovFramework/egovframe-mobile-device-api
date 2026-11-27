import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';

import '../screens/application_list_main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;
  final bool hideHomeButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.hideHomeButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    List<Widget> finalActions = [];

    if (!hideHomeButton) {
      final mainScreen = context
          .findAncestorWidgetOfExactType<ApplicationListMain>();
      final isMainScreen = mainScreen != null;

      if (!isMainScreen) {
        finalActions.add(
          IconButton(
            icon: const Icon(Icons.home, color: EgovColor.white100),
            tooltip: l10n.commonHomeTooltip,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      ApplicationListMain(title: l10n.applicationListTitle),
                ),
                (route) => false,
              );
            },
          ),
        );
      }
    }

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
