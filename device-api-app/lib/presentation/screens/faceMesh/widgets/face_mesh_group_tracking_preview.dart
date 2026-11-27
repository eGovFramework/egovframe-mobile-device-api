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

/// ?? ??? ????? ??? ????? + ??? ?????? ??? tracking box
class FaceMeshGroupTrackingPreview extends StatelessWidget {
  final List<FaceMeshRecord> records;

  const FaceMeshGroupTrackingPreview({
    super.key,
    required this.records,
  });

  Rect? _boundingBox(FaceMeshRecord record) {
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

  Size? _imageSize(FaceMeshRecord record) {
    final width = double.tryParse(record.imageWidth ?? '');
    final height = double.tryParse(record.imageHeight ?? '');
    if (width == null || height == null || width <= 0 || height <= 0) {
      return null;
    }
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    // ????? ??/???????? group ??record ?? ?? ???????????????? 1?? ???.
    final representative = records.firstWhere(
      (r) => (r.imagePath?.trim().isNotEmpty ?? false),
      orElse: () => records.first,
    );

    final imagePath = representative.imagePath?.trim();
    final imageFile = (imagePath != null && imagePath.isNotEmpty)
        ? File(imagePath)
        : null;

    final imageSize = _imageSize(representative);

    final faces = <DetectedFaceMeshInfo>[];
    final labels = <String>[];
    for (final record in records) {
      final box = _boundingBox(record);
      if (box == null) continue;

      faces.add(
        DetectedFaceMeshInfo(
          boundingBox: box,
          landmarks: const [],
          normalizedLandmarks: [
            for (final p in [
              FaceMeshDisplayMath.tryParsePoint(
                record.noseTipX,
                record.noseTipY,
              ),
              FaceMeshDisplayMath.tryParsePoint(
                record.leftEyeX,
                record.leftEyeY,
              ),
              FaceMeshDisplayMath.tryParsePoint(
                record.rightEyeX,
                record.rightEyeY,
              ),
              FaceMeshDisplayMath.tryParsePoint(
                record.mouthCenterX,
                record.mouthCenterY,
              ),
            ])
              if (p != null) p,
          ],
          landmarkCount: int.tryParse(record.landmarkCount ?? '') ?? 0,
          hasIris: record.hasIris == 'Y',
        ),
      );

      final faceIndex = record.faceIndex;
      labels.add(
        (faceIndex != null && faceIndex.isNotEmpty) ? '#$faceIndex' : '#${record.sn}',
      );
    }

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
        if (imageFile == null || !imageFile.existsSync())
          InfoBox(text: l10n.faceMeshTrackingImageUnavailable)
        else if (imageSize == null)
          InfoBox(text: l10n.faceMeshTrackingBoxUnavailable)
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: imageSize.width / imageSize.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(imageFile, fit: BoxFit.fill),
                  if (faces.isNotEmpty)
                    CustomPaint(
                      painter: FaceMeshOverlayPainter(
                        faces: faces,
                        imageSize: imageSize,
                        labels: labels,
                        renderMode: FaceMeshRenderMode.points,
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

