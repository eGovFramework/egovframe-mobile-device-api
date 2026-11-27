import 'dart:math' as math;
import 'dart:ui';

/// MediaPipe Face Mesh 표준 landmark 인덱스 (확장/AR 앵커용).
abstract final class FaceMeshLandmarkIndex {
  static const noseTip = 1;
  static const leftEyeOuter = 33;
  static const leftEyeInner = 133;
  static const rightEyeOuter = 263;
  static const rightEyeInner = 362;
  static const mouthLeft = 61;
  static const mouthRight = 291;
  static const upperLip = 13;
  static const lowerLip = 14;
  static const leftIris = 468;
  static const rightIris = 473;
}

/// 정규화 landmark에서 뽑은 Face Mesh 확장용 지표.
class FaceMeshDerivedMetrics {
  final Offset? noseTip;
  final Offset? leftEye;
  final Offset? rightEye;
  final Offset? mouthCenter;
  final double? interocularDistance;
  final bool hasIris;

  const FaceMeshDerivedMetrics({
    this.noseTip,
    this.leftEye,
    this.rightEye,
    this.mouthCenter,
    this.interocularDistance,
    this.hasIris = false,
  });

  static FaceMeshDerivedMetrics fromNormalizedLandmarks(
    List<Offset> normalized,
  ) {
    if (normalized.isEmpty) {
      return const FaceMeshDerivedMetrics();
    }

    final hasIris = normalized.length >= 478;
    final noseTip = _at(normalized, FaceMeshLandmarkIndex.noseTip);
    final leftEye = hasIris
        ? _at(normalized, FaceMeshLandmarkIndex.leftIris)
        : _mid(
            normalized,
            FaceMeshLandmarkIndex.leftEyeOuter,
            FaceMeshLandmarkIndex.leftEyeInner,
          );
    final rightEye = hasIris
        ? _at(normalized, FaceMeshLandmarkIndex.rightIris)
        : _mid(
            normalized,
            FaceMeshLandmarkIndex.rightEyeOuter,
            FaceMeshLandmarkIndex.rightEyeInner,
          );
    final mouthCenter = _mid(
      normalized,
      FaceMeshLandmarkIndex.upperLip,
      FaceMeshLandmarkIndex.lowerLip,
    );

    double? iod;
    if (leftEye != null && rightEye != null) {
      iod = (leftEye - rightEye).distance;
    }

    return FaceMeshDerivedMetrics(
      noseTip: noseTip,
      leftEye: leftEye,
      rightEye: rightEye,
      mouthCenter: mouthCenter,
      interocularDistance: iod,
      hasIris: hasIris,
    );
  }

  static Offset? _at(List<Offset> points, int index) {
    if (index < 0 || index >= points.length) return null;
    return points[index];
  }

  static Offset? _mid(List<Offset> points, int a, int b) {
    final pa = _at(points, a);
    final pb = _at(points, b);
    if (pa == null || pb == null) return null;
    return Offset((pa.dx + pb.dx) / 2, (pa.dy + pb.dy) / 2);
  }
}

/// bbox / 이미지 대비 얼굴 점유율 등 표시용 계산.
abstract final class FaceMeshDisplayMath {
  static double? faceCoveragePercent(Rect bbox, Size imageSize) {
    if (imageSize.width <= 0 || imageSize.height <= 0) return null;
    final area = bbox.width * bbox.height;
    if (area <= 0) return null;
    final pct = (area / (imageSize.width * imageSize.height)) * 100;
    return pct.clamp(0, 100);
  }

  static String formatNormPoint(Offset? p, {int digits = 4}) {
    if (p == null) return '-';
    return '(${p.dx.toStringAsFixed(digits)}, ${p.dy.toStringAsFixed(digits)})';
  }

  static String formatNormDistance(double? value, {int digits = 4}) {
    if (value == null || value.isNaN) return '-';
    return value.toStringAsFixed(digits);
  }

  static String formatPercent(double? value, {int digits = 1}) {
    if (value == null || value.isNaN) return '-';
    return '${value.toStringAsFixed(digits)}%';
  }

  static String formatScore(double? value, {int digits = 4}) {
    if (value == null || value.isNaN) return '-';
    return value.toStringAsFixed(digits);
  }

  static String formatAngle(double? value, {int digits = 4}) {
    if (value == null || value.isNaN) return '-';
    return '${value.toStringAsFixed(digits)}°';
  }

  /// DB/업로드용 고정 소수 (기본 4자리). VARCHAR(10)과 맞춤.
  static const int storageDigits = 4;

  static String? toStorageString(double? value, {int digits = storageDigits}) {
    if (value == null || value.isNaN || !value.isFinite) return null;
    return value.toStringAsFixed(digits);
  }

  static double? tryParseDouble(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return double.tryParse(raw);
  }

  static Offset? tryParsePoint(String? x, String? y) {
    final dx = tryParseDouble(x);
    final dy = tryParseDouble(y);
    if (dx == null || dy == null) return null;
    if (!dx.isFinite || !dy.isFinite) return null;
    return Offset(dx, dy);
  }

  static double hypot(double ax, double ay, double bx, double by) {
    final dx = ax - bx;
    final dy = ay - by;
    return math.sqrt(dx * dx + dy * dy);
  }
}
