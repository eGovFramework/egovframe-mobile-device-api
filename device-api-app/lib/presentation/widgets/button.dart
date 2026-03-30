import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? pressedColor;
  final Color? normalColor;
  final Duration animationDuration;
  final double? fontSize;
  final double? horizontalPadding;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.pressedColor,
    this.normalColor,
    this.animationDuration = const Duration(milliseconds: 150),
    this.fontSize,
    this.horizontalPadding,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  bool isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null || widget.isLoading;
    final normalColor = isDisabled 
        ? EgovColor.gray20 
        : (widget.normalColor ?? EgovColor.primary50);
    final pressedColor = widget.pressedColor ?? normalColor.withValues(alpha: 0.7);
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.width ?? 78,
        minHeight: widget.height ?? 48,
      ),
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onTap,
        onTapDown: (_) {
          setState(() => isPressed = true);
          _animationController.forward();
        },
        onTapUp: (_) {
          setState(() => isPressed = false);
          _animationController.reverse();
        },
        onTapCancel: () {
          setState(() => isPressed = false);
          _animationController.reverse();
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
                              child: Container(
                  height: widget.height ?? 48,
                  padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 16),
                  decoration: BoxDecoration(
                    color: isPressed ? pressedColor : normalColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isPressed 
                      ? [
                          BoxShadow(
                            color: EgovColor.black10,
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: EgovColor.black50,
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                          BoxShadow(
                            color: EgovColor.black10,
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                  ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            isDisabled ? EgovColor.gray70 : EgovColor.white100,
                            BlendMode.srcIn,
                          ),
                          child: widget.icon,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDisabled ? EgovColor.gray70 : EgovColor.white100,
                          fontSize: widget.fontSize ?? 17,
                          fontFamily: 'Pretendard GOV',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BottomButtonRow extends StatelessWidget {
  final List<Widget> buttons;
  final double? height;
  final EdgeInsets? padding;

  const BottomButtonRow({
    super.key,
    required this.buttons,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 113,
      padding: padding ?? const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: 32,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: buttons.asMap().entries.map((entry) {
          final index = entry.key;
          final button = entry.value;
          return Expanded(
            child: index > 0 
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SizedBox(
                    height: 48,
                    child: button,
                  ),
                )
              : SizedBox(
                  height: 48,
                  child: button,
                ),
          );
        }).toList(),
      ),
    );
  }
}
