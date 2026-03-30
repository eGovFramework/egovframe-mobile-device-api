
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<String> tabs;
  final Function(int)? onTap;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      // 상태 업데이트를 위해 빈 setState 호출
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      height: 56, // 고정 높이
      decoration: BoxDecoration(
        color: EgovColor.primary50, // AppBar와 같은 배경색
      ),
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          final isSelected = widget.controller.index == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.controller.animateTo(index);
                widget.onTap?.call(index);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isSelected 
                    ? EgovColor.secondary70 
                    : EgovColor.white100,
                ),
                child: Center(
                  child: Text(
                    widget.tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected 
                        ? EgovColor.white100 
                        : EgovColor.gray70,
                      fontSize: _getResponsiveFontSize(screenWidth),
                      fontFamily: 'Pretendard GOV',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  double _getResponsiveFontSize(double screenWidth) {
    if (screenWidth < 320) return 14; // 작은 화면
    if (screenWidth < 480) return 16; // 중간 화면
    if (screenWidth < 768) return 18; // 큰 화면
    return 19; // 매우 큰 화면
  }
}

// 기존 Tabbar 클래스는 하위 호환성을 위해 유지
class Tabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 80),
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: EgovColor.white0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(
                              0xFFB1B8BE) /* color-border-gray */,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: ShapeDecoration(
                                    color: EgovColor.gray90,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '바로가기',
                          textAlign: TextAlign.center,
                          style: EgovText.buttonText.copyWith(
                            color: EgovColor.gray90,
                            fontSize: 17,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 80),
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: EgovColor.white0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(
                              0xFFB1B8BE) /* color-border-gray */,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: ShapeDecoration(
                                    color: EgovColor.gray90,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '바로가기',
                          textAlign: TextAlign.center,
                          style: EgovText.buttonText.copyWith(
                            color: EgovColor.gray90,
                            fontSize: 17,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
