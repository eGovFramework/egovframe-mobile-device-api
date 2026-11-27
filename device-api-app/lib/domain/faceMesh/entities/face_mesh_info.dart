import 'dart:ui';

import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_geometry.dart';

/// MediaPipe Face Mesh로 감지된 얼굴 1건 (mesh 핵심 지표만)
class DetectedFaceMeshInfo {
  final Rect boundingBox;

  /// 픽셀 좌표 landmark (정적 이미지 등). 실시간은 [normalizedLandmarks] 우선.
  final List<Offset> landmarks;

  /// 0~1 정규화 landmark (MediaPipe 원본). 오버레이 회전/미러 매핑에 사용.
  final List<Offset> normalizedLandmarks;

  final int landmarkCount;

  /// MediaPipe detection/mesh confidence
  final double? score;
  final int? trackingId;

  /// iris 포함 시 보통 478
  final bool hasIris;

  /// 정규화 앵커 (AR/확장용)
  final Offset? noseTipNorm;
  final Offset? leftEyeNorm;
  final Offset? rightEyeNorm;
  final Offset? mouthCenterNorm;

  /// 양안 거리 (정규화 좌표 거리) — 스케일 기준
  final double? interocularDistanceNorm;

  /// mesh geometry head pose (pitch / yaw / roll)
  final double? headEulerAngleX;
  final double? headEulerAngleY;
  final double? headEulerAngleZ;

  const DetectedFaceMeshInfo({
    required this.boundingBox,
    this.landmarks = const [],
    this.normalizedLandmarks = const [],
    this.landmarkCount = 0,
    this.score,
    this.trackingId,
    this.hasIris = false,
    this.noseTipNorm,
    this.leftEyeNorm,
    this.rightEyeNorm,
    this.mouthCenterNorm,
    this.interocularDistanceNorm,
    this.headEulerAngleX,
    this.headEulerAngleY,
    this.headEulerAngleZ,
  });

  factory DetectedFaceMeshInfo.fromMeshParts({
    required Rect boundingBox,
    required List<Offset> normalizedLandmarks,
    List<Offset> landmarks = const [],
    required int landmarkCount,
    double? score,
    int? trackingId,
    double? headEulerAngleX,
    double? headEulerAngleY,
    double? headEulerAngleZ,
  }) {
    final derived =
        FaceMeshDerivedMetrics.fromNormalizedLandmarks(normalizedLandmarks);
    return DetectedFaceMeshInfo(
      boundingBox: boundingBox,
      landmarks: landmarks,
      normalizedLandmarks: normalizedLandmarks,
      landmarkCount: landmarkCount,
      score: score,
      trackingId: trackingId,
      hasIris: derived.hasIris || landmarkCount >= 478,
      noseTipNorm: derived.noseTip,
      leftEyeNorm: derived.leftEye,
      rightEyeNorm: derived.rightEye,
      mouthCenterNorm: derived.mouthCenter,
      interocularDistanceNorm: derived.interocularDistance,
      headEulerAngleX: headEulerAngleX,
      headEulerAngleY: headEulerAngleY,
      headEulerAngleZ: headEulerAngleZ,
    );
  }
}

/// 이미지 기반 Face Mesh 세션 결과
class FaceMeshSession {
  final String? imagePath;
  final Size imageSize;
  final List<DetectedFaceMeshInfo> faces;
  final DateTime detectedAt;

  /// 'camera' | 'gallery' — 저장 시 source 컬럼에 사용
  final String? source;

  const FaceMeshSession({
    this.imagePath,
    required this.imageSize,
    required this.faces,
    required this.detectedAt,
    this.source,
  });

  bool get hasFaces => faces.isNotEmpty;

  int get faceCount => faces.length;

  FaceMeshSession copyWith({
    String? imagePath,
    Size? imageSize,
    List<DetectedFaceMeshInfo>? faces,
    DateTime? detectedAt,
    String? source,
  }) {
    return FaceMeshSession(
      imagePath: imagePath ?? this.imagePath,
      imageSize: imageSize ?? this.imageSize,
      faces: faces ?? this.faces,
      detectedAt: detectedAt ?? this.detectedAt,
      source: source ?? this.source,
    );
  }

  factory FaceMeshSession.empty() {
    return FaceMeshSession(
      imageSize: Size.zero,
      faces: const [],
      detectedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
