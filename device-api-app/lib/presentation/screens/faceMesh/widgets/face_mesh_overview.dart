import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_geometry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_painter.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/label_value.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:flutter/material.dart';

class FaceMeshOverview extends StatelessWidget {
  final FaceMeshSession? session;
  final bool isProcessing;
  final VoidCallback onPickImageTap;
  final VoidCallback onLiveCameraTap;
  final Widget? footer;

  const FaceMeshOverview({
    super.key,
    required this.session,
    required this.isProcessing,
    required this.onPickImageTap,
    required this.onLiveCameraTap,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasResult = session != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isProcessing)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (!hasResult)
          InfoBox(text: l10n.faceMeshNoResultYet)
        else
          _ResultSection(session: session!),
        const SizedBox(height: 24),
        CustomButton(
          text: l10n.faceMeshPickImageButton,
          onTap: isProcessing ? null : onPickImageTap,
          icon: const Icon(
            Icons.image_outlined,
            color: EgovColor.white100,
            size: 20,
          ),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: l10n.faceMeshLiveCameraButton,
          onTap: isProcessing ? null : onLiveCameraTap,
          normalColor: EgovColor.gray80,
          pressedColor: EgovColor.gray90,
          icon: const Icon(
            Icons.videocam_outlined,
            color: EgovColor.white100,
            size: 20,
          ),
        ),
        if (footer != null) ...[
          const SizedBox(height: 16),
          footer!,
        ],
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  final FaceMeshSession session;

  const _ResultSection({required this.session});

  @override
  Widget build(BuildContext context) {
    final path = session.imagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelValueGroup(
          entries: [
            LabelValueEntry(
              label: '감지 얼굴 수',
              value: '${session.faceCount}',
            ),
            LabelValueEntry(
              label: '감지 시각',
              value: KstDateTimeUtil.format(session.detectedAt),
            ),
            LabelValueEntry(
              label: '이미지 크기',
              value: session.imageSize.width > 0
                  ? '${session.imageSize.width.toStringAsFixed(0)} x '
                      '${session.imageSize.height.toStringAsFixed(0)}'
                  : '-',
            ),
          ],
        ),
        if (path != null && File(path).existsSync()) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: session.imageSize.width > 0 &&
                      session.imageSize.height > 0
                  ? session.imageSize.width / session.imageSize.height
                  : 3 / 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(path), fit: BoxFit.fill),
                      CustomPaint(
                        painter: FaceMeshOverlayPainter(
                          faces: session.faces,
                          imageSize: session.imageSize,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
        if (session.faces.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Face Mesh 상세',
            style: EgovText.medium.copyWith(
              fontWeight: FontWeight.w700,
              color: EgovColor.gray90,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < session.faces.length; i++)
            _FaceDetailCard(
              index: i + 1,
              face: session.faces[i],
              imageSize: session.imageSize,
            ),
        ],
      ],
    );
  }
}

class _FaceDetailCard extends StatelessWidget {
  final int index;
  final DetectedFaceMeshInfo face;
  final Size imageSize;

  const _FaceDetailCard({
    required this.index,
    required this.face,
    required this.imageSize,
  });

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        '$label: $value',
        style: EgovText.caption.copyWith(color: EgovColor.gray70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = face.boundingBox;
    final coverage = FaceMeshDisplayMath.faceCoveragePercent(box, imageSize);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EgovColor.white100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '얼굴 #$index',
            style: EgovText.medium.copyWith(
              fontWeight: FontWeight.w700,
              color: EgovColor.primary50,
            ),
          ),
          const SizedBox(height: 8),
          _line(
            '랜드마크 수',
            '${face.landmarkCount}'
            '${face.hasIris ? ' (iris 포함)' : ' (표면 mesh)'}',
          ),
          _line('신뢰도(score)', FaceMeshDisplayMath.formatScore(face.score)),
          _line(
            '트래킹 ID',
            face.trackingId?.toString() ?? '-',
          ),
          _line(
            '얼굴 점유율',
            FaceMeshDisplayMath.formatPercent(coverage),
          ),
          _line(
            'BBox 크기',
            '${box.width.toStringAsFixed(0)} x ${box.height.toStringAsFixed(0)}',
          ),
          _line(
            '양안 거리(정규화)',
            FaceMeshDisplayMath.formatNormDistance(
              face.interocularDistanceNorm,
            ),
          ),
          _line(
            '코끝 앵커',
            FaceMeshDisplayMath.formatNormPoint(face.noseTipNorm),
          ),
          _line(
            '왼쪽 눈 앵커',
            FaceMeshDisplayMath.formatNormPoint(face.leftEyeNorm),
          ),
          _line(
            '오른쪽 눈 앵커',
            FaceMeshDisplayMath.formatNormPoint(face.rightEyeNorm),
          ),
          _line(
            '입 중앙 앵커',
            FaceMeshDisplayMath.formatNormPoint(face.mouthCenterNorm),
          ),
          _line(
            '머리끄덕임',
            FaceMeshDisplayMath.formatAngle(face.headEulerAngleX),
          ),
          _line(
            '좌우회전',
            FaceMeshDisplayMath.formatAngle(face.headEulerAngleY),
          ),
          _line(
            '머리기울기',
            FaceMeshDisplayMath.formatAngle(face.headEulerAngleZ),
          ),
        ],
      ),
    );
  }
}
