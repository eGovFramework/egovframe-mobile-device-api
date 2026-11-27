import 'dart:io';

import 'package:camera/camera.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';

/// Face Mesh overlay: bounding box + landmark points
enum FaceMeshRenderMode { points, wireApprox, boxOnly }

class FaceMeshOverlayPainter extends CustomPainter {
  final List<DetectedFaceMeshInfo> faces;
  final Size imageSize;
  final int rotationDegrees;
  final bool mirrorHorizontal;
  final List<String>? labels;
  final FaceMeshRenderMode renderMode;

  FaceMeshOverlayPainter({
    required this.faces,
    required this.imageSize,
    this.rotationDegrees = 0,
    this.mirrorHorizontal = false,
    this.labels,
    this.renderMode = FaceMeshRenderMode.points,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = EgovColor.primary50;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = EgovColor.primary50.withValues(alpha: 0.08);

    final pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = EgovColor.primary50;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = EgovColor.primary50.withValues(alpha: 0.55);

    for (var i = 0; i < faces.length; i++) {
      final face = faces[i];
      final mapped = _mapFacePoints(face, size);
      // landmark가 없어도 boundingBox로 트래킹 박스 표시 (상세/목록 저장 결과)
      final rect = _mappedBoundingBox(face, size) ??
          (mapped.isNotEmpty ? _boundsOf(mapped) : null);
      if (rect == null) continue;

      if (renderMode != FaceMeshRenderMode.points) {
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, boxPaint);
      } else {
        canvas.drawRect(rect, boxPaint);
      }

      if (renderMode == FaceMeshRenderMode.wireApprox && mapped.length > 1) {
        for (var j = 0; j + 1 < mapped.length; j += 3) {
          canvas.drawLine(mapped[j], mapped[j + 1], linePaint);
        }
      }

      if (renderMode != FaceMeshRenderMode.boxOnly && mapped.isNotEmpty) {
        final radius = mapped.length <= 8 ? 3.0 : 1.15;
        for (final p in mapped) {
          canvas.drawCircle(p, radius, pointPaint);
        }
      }

      final label =
          (labels != null && i < labels!.length && labels![i].isNotEmpty)
              ? labels![i]
              : '#${i + 1} (${face.landmarkCount})';
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: EgovColor.white100,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelTop = (rect.top - 20).clamp(0.0, size.height);
      final labelLeft = rect.left.clamp(0.0, size.width);
      final labelRect = Rect.fromLTWH(
        labelLeft,
        labelTop,
        textPainter.width + 8,
        18,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
        Paint()..color = EgovColor.primary50,
      );
      textPainter.paint(canvas, Offset(labelRect.left + 4, labelRect.top + 2));
    }
  }

  /// 픽셀 bbox → 캔버스 rect (상세/저장 결과용)
  Rect? _mappedBoundingBox(DetectedFaceMeshInfo face, Size canvasSize) {
    if (imageSize.width <= 0 || imageSize.height <= 0) return null;
    final b = face.boundingBox;
    if (b.width <= 0 || b.height <= 0) return null;

    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;
    return Rect.fromLTRB(
      b.left * scaleX,
      b.top * scaleY,
      b.right * scaleX,
      b.bottom * scaleY,
    );
  }

  List<Offset> _mapFacePoints(DetectedFaceMeshInfo face, Size canvasSize) {
    if (face.normalizedLandmarks.isNotEmpty) {
      return [
        for (final n in face.normalizedLandmarks)
          _mapNormalized(n, canvasSize),
      ];
    }

    if (face.landmarks.isEmpty ||
        imageSize.width <= 0 ||
        imageSize.height <= 0) {
      return const [];
    }
    return [
      for (final p in face.landmarks)
        Offset(
          p.dx * canvasSize.width / imageSize.width,
          p.dy * canvasSize.height / imageSize.height,
        ),
    ];
  }

  /// mediapipe_face_mesh FaceMeshPainter와 동일한 매핑 (균등 스케일, 비율 유지)
  Offset _mapNormalized(Offset landmark, Size canvasSize) {
    var x = landmark.dx;
    var y = landmark.dy;

    switch (rotationDegrees) {
      case 90:
        x = 1.0 - landmark.dy;
        y = landmark.dx;
        break;
      case 180:
        x = 1.0 - landmark.dx;
        y = 1.0 - landmark.dy;
        break;
      case 270:
        x = landmark.dy;
        y = 1.0 - landmark.dx;
        break;
      case 0:
      default:
        break;
    }

    if (mirrorHorizontal) {
      x = 1.0 - x;
    }

    return Offset(x * canvasSize.width, y * canvasSize.height);
  }

  Rect _boundsOf(List<Offset> points) {
    var minX = points.first.dx;
    var maxX = points.first.dx;
    var minY = points.first.dy;
    var maxY = points.first.dy;
    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  bool shouldRepaint(covariant FaceMeshOverlayPainter oldDelegate) {
    return oldDelegate.faces != faces ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.rotationDegrees != rotationDegrees ||
        oldDelegate.mirrorHorizontal != mirrorHorizontal ||
        oldDelegate.labels != labels ||
        oldDelegate.renderMode != renderMode;
  }
}

/// Android 전면 카메라 프리뷰 미러 여부 (공식 예제와 동일)
bool faceMeshShouldMirrorPreview(CameraLensDirection lens) {
  return !Platform.isIOS && lens == CameraLensDirection.front;
}
