import 'dart:math' as math;

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';

/// 카메라 미리보기 위 스캔 영역 가이드(어두운 마스크 + 테두리).
class BarcodeScanOverlay extends CustomPainter {
  const BarcodeScanOverlay({
    required this.scanWindow,
    this.borderRadius = 12,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 0.55)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver;

    canvas.drawPath(
      Path.combine(PathOperation.difference, backgroundPath, cutoutPath),
      backgroundPaint,
    );

    final borderPaint = Paint()
      ..color = EgovColor.white100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        scanWindow,
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(BarcodeScanOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}

/// flutter_zxing(ReaderWidget)의 디코딩 영역과 동일한 스캔 가이드 영역을 계산한다.
///
/// ReaderWidget은 카메라 프레임의 짧은 변 * [cropPercent] 크기의 정사각형을
/// 중앙에서 잘라 디코딩하므로, 가이드 영역도 같은 방식(중앙 정사각형)으로 맞춘다.
Rect barcodeScanWindowForSize(Size size, {required double cropPercent}) {
  final side = math.min(size.width, size.height) * cropPercent;

  return Rect.fromCenter(
    center: Offset(size.width / 2, size.height / 2),
    width: side,
    height: side,
  );
}
