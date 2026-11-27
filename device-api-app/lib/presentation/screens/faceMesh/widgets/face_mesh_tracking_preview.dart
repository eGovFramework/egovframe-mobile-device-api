import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_geometry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_painter.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:flutter/material.dart';

/// 상세 화면: 원본 이미지 + 얼굴영역(박스) + 저장 앵커 점
class FaceMeshTrackingPreview extends StatelessWidget {
  final FaceMeshRecord record;

  const FaceMeshTrackingPreview({super.key, required this.record});

  Rect? _boundingBox() {
    final left = double.tryParse(record.bboxLeft ?? '');
    final top = double.tryParse(record.bboxTop ?? '');
    final right = double.tryParse(record.bboxRight ?? '');
    final bottom = double.tryParse(record.bboxBottom ?? '');
    if (left == null || top == null || right == null || bottom == null) {
      return null;
    }
    if (right <= left || bottom <= top) return null;
    return Rect.fromLTRB(left, top, right, bottom);
  }

  Size? _imageSize() {
    final width = double.tryParse(record.imageWidth ?? '');
    final height = double.tryParse(record.imageHeight ?? '');
    if (width == null || height == null || width <= 0 || height <= 0) {
      return null;
    }
    return Size(width, height);
  }

  List<Offset> _anchorPoints() {
    final points = <Offset>[];
    void add(String? x, String? y) {
      final p = FaceMeshDisplayMath.tryParsePoint(x, y);
      if (p != null) points.add(p);
    }

    add(record.noseTipX, record.noseTipY);
    add(record.leftEyeX, record.leftEyeY);
    add(record.rightEyeX, record.rightEyeY);
    add(record.mouthCenterX, record.mouthCenterY);
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final path = record.imagePath?.trim();
    final fileExists = path != null && path.isNotEmpty && File(path).existsSync();
    final box = _boundingBox();
    final imageSize = _imageSize();
    final anchors = _anchorPoints();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.faceMeshTrackingImageTitle,
          style: EgovText.medium.copyWith(
            fontWeight: FontWeight.w700,
            color: EgovColor.gray90,
          ),
        ),
        const SizedBox(height: 8),
        if (!fileExists)
          InfoBox(text: l10n.faceMeshTrackingImageUnavailable)
        else if (box == null || imageSize == null)
          InfoBox(text: l10n.faceMeshTrackingBoxUnavailable)
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: imageSize.width / imageSize.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(path), fit: BoxFit.fill),
                  CustomPaint(
                    painter: FaceMeshOverlayPainter(
                      faces: [
                        DetectedFaceMeshInfo(
                          boundingBox: box,
                          landmarks: const [],
                          normalizedLandmarks: anchors,
                          landmarkCount: int.tryParse(
                                record.landmarkCount ?? '',
                              ) ??
                              0,
                          hasIris: record.hasIris == 'Y',
                          noseTipNorm: FaceMeshDisplayMath.tryParsePoint(
                            record.noseTipX,
                            record.noseTipY,
                          ),
                          leftEyeNorm: FaceMeshDisplayMath.tryParsePoint(
                            record.leftEyeX,
                            record.leftEyeY,
                          ),
                          rightEyeNorm: FaceMeshDisplayMath.tryParsePoint(
                            record.rightEyeX,
                            record.rightEyeY,
                          ),
                          mouthCenterNorm: FaceMeshDisplayMath.tryParsePoint(
                            record.mouthCenterX,
                            record.mouthCenterY,
                          ),
                        ),
                      ],
                      imageSize: imageSize,
                      // 박스 + 저장 앵커(코/눈/입) 점 표시
                      renderMode: FaceMeshRenderMode.points,
                      labels: [
                        record.faceIndex != null && record.faceIndex!.isNotEmpty
                            ? '#${record.faceIndex}'
                            : '#${record.sn}',
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
