import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_geometry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view_model/face_mesh_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_mesh_tracking_preview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaceMeshDetailedPage extends ConsumerStatefulWidget {
  final FaceMeshRecord record;

  const FaceMeshDetailedPage({super.key, required this.record});

  @override
  ConsumerState<FaceMeshDetailedPage> createState() =>
      _FaceMeshDetailedPageState();
}

class _FaceMeshDetailedPageState
    extends ConsumerState<FaceMeshDetailedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(faceMeshDetailProvider(widget.record.sn).notifier)
          .initialize(widget.record);
    });
  }

  Future<void> _confirmAndDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.faceMeshDeleteTitle,
      message: l10n.faceMeshDeleteConfirm,
    );
    if (!confirmed || !mounted) return;

    await _deleteRecord();
  }

  Future<void> _deleteRecord() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(faceMeshDetailProvider(widget.record.sn).notifier)
        .deleteRecord();

    if (!mounted) return;

    switch (result) {
      case FaceMeshDeleteBatchSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.faceMeshDeleteSuccess,
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      case FaceMeshDeleteBatchFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  String _display(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    return value;
  }

  String _formatAngle(String? raw) {
    return FaceMeshDisplayMath.formatAngle(
      FaceMeshDisplayMath.tryParseDouble(raw),
    );
  }

  String _formatScore(String? raw) {
    return FaceMeshDisplayMath.formatScore(
      FaceMeshDisplayMath.tryParseDouble(raw),
    );
  }

  String _formatNorm(String? raw) {
    return FaceMeshDisplayMath.formatNormDistance(
      FaceMeshDisplayMath.tryParseDouble(raw),
    );
  }

  String _formatPoint(String? x, String? y) {
    return FaceMeshDisplayMath.formatNormPoint(
      FaceMeshDisplayMath.tryParsePoint(x, y),
    );
  }

  String _irisLabel(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      final count = int.tryParse(widget.record.landmarkCount ?? '');
      if (count != null && count >= 478) return 'Y (iris)';
      if (count != null) return 'N (표면 mesh)';
      return '-';
    }
    final normalized = raw.trim().toUpperCase();
    if (normalized == 'Y' || normalized == 'TRUE' || normalized == '1') {
      return 'Y (iris)';
    }
    if (normalized == 'N' || normalized == 'FALSE' || normalized == '0') {
      return 'N (표면 mesh)';
    }
    return raw;
  }

  List<Map<String, String>> _buildDetailTableData(
    AppLocalizations l10n,
    FaceMeshRecord record,
  ) {
    final left = FaceMeshDisplayMath.tryParseDouble(record.bboxLeft);
    final top = FaceMeshDisplayMath.tryParseDouble(record.bboxTop);
    final right = FaceMeshDisplayMath.tryParseDouble(record.bboxRight);
    final bottom = FaceMeshDisplayMath.tryParseDouble(record.bboxBottom);
    final bboxW = (left != null && right != null) ? (right - left) : null;
    final bboxH = (top != null && bottom != null) ? (bottom - top) : null;

    return [
      {'label': l10n.faceMeshSerialNumber, 'value': '${record.sn}'},
      {'label': l10n.faceMeshUuidLabel, 'value': _display(record.uuid)},
      {
        'label': l10n.faceMeshUseStatus,
        'value': record.useYn == 'Y'
            ? l10n.faceMeshInUse
            : l10n.faceMeshNotInUse,
      },
      {
        'label': '감지 시각',
        'value': _display(record.timestamp),
      },
      {
        'label': '얼굴 그룹 ID',
        'value': record.faceGroupId,
      },
      {
        'label': '입력 소스',
        'value': _display(record.source),
      },
      {
        'label': '이미지 경로',
        'value': _display(record.imagePath),
      },
      {
        'label': '이미지 크기',
        'value': (record.imageWidth == null && record.imageHeight == null)
            ? '-'
            : '${_display(record.imageWidth)} x ${_display(record.imageHeight)}',
      },
      {
        'label': '감지 얼굴 수',
        'value': _display(record.faceCount),
      },
      {
        'label': '얼굴 인덱스',
        'value': _display(record.faceIndex),
      },
      {
        'label': '트래킹 ID',
        'value': _display(record.trackingId),
      },
      {
        'label': '랜드마크 수',
        'value': _display(record.landmarkCount),
      },
      {
        'label': 'Iris 포함',
        'value': _irisLabel(record.hasIris),
      },
      {
        'label': '신뢰도',
        'value': _formatScore(record.meshScore),
      },
      {
        'label': '양안 거리',
        'value': _formatNorm(record.iodNorm),
      },
      {
        'label': '코끝',
        'value': _formatPoint(record.noseTipX, record.noseTipY),
      },
      {
        'label': '왼쪽 눈',
        'value': _formatPoint(record.leftEyeX, record.leftEyeY),
      },
      {
        'label': '오른쪽 눈',
        'value': _formatPoint(record.rightEyeX, record.rightEyeY),
      },
      {
        'label': '입 중앙',
        'value': _formatPoint(record.mouthCenterX, record.mouthCenterY),
      },
      {
        'label': 'BBox',
        'value':
            'Left ${_display(record.bboxLeft)},\n'
            'Top ${_display(record.bboxTop)},\n'
            'Right ${_display(record.bboxRight)},\n'
            'Bottom ${_display(record.bboxBottom)}',
      },
      {
        'label': 'BBox 크기',
        'value': (bboxW == null || bboxH == null)
            ? '-'
            : '${bboxW.toStringAsFixed(0)} x ${bboxH.toStringAsFixed(0)}',
      },
      {
        'label': '머리끄덕임',
        'value': _formatAngle(record.headEulerX),
      },
      {
        'label': '좌우회전',
        'value': _formatAngle(record.headEulerY),
      },
      {
        'label': '머리기울기',
        'value': _formatAngle(record.headEulerZ),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detailState = ref.watch(
      faceMeshDetailProvider(widget.record.sn),
    );
    final record = detailState.displayRecord ?? widget.record;

    return ApiFeatureShell(
      popToApiMainCount: 3,
      feature: ApiFeature.faceMesh,
      title: l10n.faceMeshDetailTitle,
      mainFunctionBody: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FaceMeshTrackingPreview(record: record),
            const SizedBox(height: 24),
            CommonTable(
              title: 'Face Mesh 상세 정보',
              data: _buildDetailTableData(l10n, record),
            ),
          ],
        ),
      ),
      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.commonDelete,
            onTap: detailState.isDeleting ? null : _confirmAndDelete,
            icon: detailState.isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        EgovColor.white100,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.delete,
                    color: EgovColor.white100,
                    size: 20,
                  ),
          ),
        ],
      ),
    );
  }
}
