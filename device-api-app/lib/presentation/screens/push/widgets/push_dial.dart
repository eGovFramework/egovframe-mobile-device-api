import 'dart:math' as math;

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class PushDial extends StatelessWidget {
  final double? heading;
  final bool isActive;

  const PushDial({
    super.key,
    required this.heading,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final radians = (heading ?? 0) * math.pi / 180;

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: EgovColor.primary5,
              border: Border.all(color: EgovColor.primary30, width: 3),
            ),
            child: CustomPaint(
              painter: _PushMarkPainter(isActive: isActive),
            ),
          ),
          Transform.rotate(
            angle: radians,
            child: CustomPaint(
              size: const Size(120, 120),
              painter: _PushNeedlePainter(isActive: isActive),
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isActive ? EgovColor.point50 : EgovColor.gray40,
              shape: BoxShape.circle,
              border: Border.all(color: EgovColor.white100, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}

/// 북쪽을 가리키는 나침반 바늘 (방향 표시 전용)
class _PushNeedlePainter extends CustomPainter {
  final bool isActive;

  _PushNeedlePainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final northColor = isActive ? EgovColor.point50 : EgovColor.gray40;
    final southColor = isActive ? EgovColor.gray30 : EgovColor.gray20;

    final northPath = Path()
      ..moveTo(center.dx, center.dy - size.height * 0.42)
      ..lineTo(center.dx - size.width * 0.09, center.dy)
      ..lineTo(center.dx + size.width * 0.09, center.dy)
      ..close();

    final southPath = Path()
      ..moveTo(center.dx, center.dy + size.height * 0.42)
      ..lineTo(center.dx - size.width * 0.09, center.dy)
      ..lineTo(center.dx + size.width * 0.09, center.dy)
      ..close();

    canvas.drawPath(
      northPath,
      Paint()
        ..color = northColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      southPath,
      Paint()
        ..color = southColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      size.width * 0.06,
      Paint()..color = isActive ? EgovColor.primary50 : EgovColor.gray50,
    );
  }

  @override
  bool shouldRepaint(covariant _PushNeedlePainter oldDelegate) =>
      oldDelegate.isActive != isActive;
}

class _PushMarkPainter extends CustomPainter {
  final bool isActive;

  _PushMarkPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final paint = Paint()
      ..color = isActive ? EgovColor.primary50 : EgovColor.gray30
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);

    const labels = ['N', 'E', 'S', 'W'];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < labels.length; i++) {
      final angle = i * math.pi / 2;
      textPainter.text = TextSpan(
        text: labels[i],
        style: EgovText.captionBold.copyWith(
          color: isActive ? EgovColor.primary70 : EgovColor.gray40,
        ),
      );
      textPainter.layout();
      final x = center.dx +
          (radius - 18) * math.sin(angle) -
          textPainter.width / 2;
      final y = center.dy -
          (radius - 18) * math.cos(angle) -
          textPainter.height / 2;
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant _PushMarkPainter oldDelegate) =>
      oldDelegate.isActive != isActive;
}
