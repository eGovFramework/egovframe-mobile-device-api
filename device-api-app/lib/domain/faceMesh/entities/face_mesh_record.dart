import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_geometry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';

/// 얼굴 메시 저장 단위 (감지된 얼굴 1명 = 1행, mesh 핵심 필드만)
class FaceMeshRecord {
  final int sn;
  final String? uuid;
  final String useYn;
  final String timestamp;
  final String faceGroupId;
  final String? source;
  final String? imagePath;
  final String? imageWidth;
  final String? imageHeight;
  final String? faceCount;
  final String? faceIndex;
  final String? trackingId;
  final String? bboxLeft;
  final String? bboxTop;
  final String? bboxRight;
  final String? bboxBottom;
  final String? landmarkCount;
  final String? meshScore;
  final String? hasIris;
  final String? iodNorm;
  final String? noseTipX;
  final String? noseTipY;
  final String? leftEyeX;
  final String? leftEyeY;
  final String? rightEyeX;
  final String? rightEyeY;
  final String? mouthCenterX;
  final String? mouthCenterY;
  final String? headEulerX;
  final String? headEulerY;
  final String? headEulerZ;

  const FaceMeshRecord({
    required this.sn,
    this.uuid,
    required this.useYn,
    required this.timestamp,
    required this.faceGroupId,
    this.source,
    this.imagePath,
    this.imageWidth,
    this.imageHeight,
    this.faceCount,
    this.faceIndex,
    this.trackingId,
    this.bboxLeft,
    this.bboxTop,
    this.bboxRight,
    this.bboxBottom,
    this.landmarkCount,
    this.meshScore,
    this.hasIris,
    this.iodNorm,
    this.noseTipX,
    this.noseTipY,
    this.leftEyeX,
    this.leftEyeY,
    this.rightEyeX,
    this.rightEyeY,
    this.mouthCenterX,
    this.mouthCenterY,
    this.headEulerX,
    this.headEulerY,
    this.headEulerZ,
  });

  factory FaceMeshRecord.fromJson(Map<String, dynamic> json) {
    return FaceMeshRecord(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asOptionalString(json, ['uuid', 'UUID']),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      timestamp: JsonRead.asString(json, ['timestamp', 'TIMESTAMP']),
      faceGroupId: JsonRead.asString(
        json,
        ['faceGroupId', 'face_group_id', 'FACEGROUPID'],
      ),
      source: JsonRead.asOptionalString(json, ['source', 'SOURCE']),
      imagePath: JsonRead.asOptionalString(
        json,
        ['imagePath', 'image_path', 'IMAGEPATH'],
      ),
      imageWidth: JsonRead.asOptionalString(
        json,
        ['imageWidth', 'image_width', 'IMAGEWIDTH'],
      ),
      imageHeight: JsonRead.asOptionalString(
        json,
        ['imageHeight', 'image_height', 'IMAGEHEIGHT'],
      ),
      faceCount: JsonRead.asOptionalString(
        json,
        ['faceCount', 'face_count', 'FACECOUNT'],
      ),
      faceIndex: JsonRead.asOptionalString(
        json,
        ['faceIndex', 'face_index', 'FACEINDEX'],
      ),
      trackingId: JsonRead.asOptionalString(
        json,
        ['trackingId', 'tracking_id', 'TRACKINGID'],
      ),
      bboxLeft: JsonRead.asOptionalString(
        json,
        ['bboxLeft', 'bbox_left', 'BBOXLEFT'],
      ),
      bboxTop: JsonRead.asOptionalString(
        json,
        ['bboxTop', 'bbox_top', 'BBOXTOP'],
      ),
      bboxRight: JsonRead.asOptionalString(
        json,
        ['bboxRight', 'bbox_right', 'BBOXRIGHT'],
      ),
      bboxBottom: JsonRead.asOptionalString(
        json,
        ['bboxBottom', 'bbox_bottom', 'BBOXBOTTOM'],
      ),
      landmarkCount: JsonRead.asOptionalString(
        json,
        ['landmarkCount', 'landmark_count', 'LANDMARKCOUNT'],
      ),
      meshScore: JsonRead.asOptionalString(
        json,
        ['meshScore', 'mesh_score', 'MESHSCORE', 'score', 'SCORE'],
      ),
      hasIris: JsonRead.asOptionalString(
        json,
        ['hasIris', 'has_iris', 'HASIRIS'],
      ),
      iodNorm: JsonRead.asOptionalString(
        json,
        ['iodNorm', 'iod_norm', 'IODNORM'],
      ),
      noseTipX: JsonRead.asOptionalString(
        json,
        ['noseTipX', 'nose_tip_x', 'NOSETIPX'],
      ),
      noseTipY: JsonRead.asOptionalString(
        json,
        ['noseTipY', 'nose_tip_y', 'NOSETIPY'],
      ),
      leftEyeX: JsonRead.asOptionalString(
        json,
        ['leftEyeX', 'left_eye_x', 'LEFTEYEX'],
      ),
      leftEyeY: JsonRead.asOptionalString(
        json,
        ['leftEyeY', 'left_eye_y', 'LEFTEYEY'],
      ),
      rightEyeX: JsonRead.asOptionalString(
        json,
        ['rightEyeX', 'right_eye_x', 'RIGHTEYEX'],
      ),
      rightEyeY: JsonRead.asOptionalString(
        json,
        ['rightEyeY', 'right_eye_y', 'RIGHTEYEY'],
      ),
      mouthCenterX: JsonRead.asOptionalString(
        json,
        ['mouthCenterX', 'mouth_center_x', 'MOUTHCENTERX'],
      ),
      mouthCenterY: JsonRead.asOptionalString(
        json,
        ['mouthCenterY', 'mouth_center_y', 'MOUTHCENTERY'],
      ),
      headEulerX: JsonRead.asOptionalString(
        json,
        ['headEulerX', 'head_euler_x', 'HEADEULERX'],
      ),
      headEulerY: JsonRead.asOptionalString(
        json,
        ['headEulerY', 'head_euler_y', 'HEADEULERY'],
      ),
      headEulerZ: JsonRead.asOptionalString(
        json,
        ['headEulerZ', 'head_euler_z', 'HEADEULERZ'],
      ),
    );
  }

  factory FaceMeshRecord.fromSessionFace({
    required FaceMeshSession session,
    required DetectedFaceMeshInfo face,
    required int faceIndex,
    required String uuid,
    required String source,
    required String faceGroupId,
    int sn = 0,
  }) {
    final box = face.boundingBox;
    String? f4(double? v) => FaceMeshDisplayMath.toStorageString(v);

    return FaceMeshRecord(
      sn: sn,
      uuid: uuid,
      useYn: 'Y',
      timestamp: KstDateTimeUtil.format(session.detectedAt),
      faceGroupId: faceGroupId,
      source: source,
      imagePath: session.imagePath,
      imageWidth: session.imageSize.width > 0
          ? session.imageSize.width.toStringAsFixed(0)
          : null,
      imageHeight: session.imageSize.height > 0
          ? session.imageSize.height.toStringAsFixed(0)
          : null,
      faceCount: '${session.faceCount}',
      faceIndex: '$faceIndex',
      trackingId: face.trackingId?.toString(),
      bboxLeft: f4(box.left),
      bboxTop: f4(box.top),
      bboxRight: f4(box.right),
      bboxBottom: f4(box.bottom),
      landmarkCount: face.landmarkCount.toString(),
      meshScore: f4(face.score),
      hasIris: face.hasIris ? 'Y' : 'N',
      iodNorm: f4(face.interocularDistanceNorm),
      noseTipX: f4(face.noseTipNorm?.dx),
      noseTipY: f4(face.noseTipNorm?.dy),
      leftEyeX: f4(face.leftEyeNorm?.dx),
      leftEyeY: f4(face.leftEyeNorm?.dy),
      rightEyeX: f4(face.rightEyeNorm?.dx),
      rightEyeY: f4(face.rightEyeNorm?.dy),
      mouthCenterX: f4(face.mouthCenterNorm?.dx),
      mouthCenterY: f4(face.mouthCenterNorm?.dy),
      headEulerX: f4(face.headEulerAngleX),
      headEulerY: f4(face.headEulerAngleY),
      headEulerZ: f4(face.headEulerAngleZ),
    );
  }

  static List<FaceMeshRecord> fromSession(
    FaceMeshSession session, {
    required String uuid,
    required String source,
    required String faceGroupId,
  }) {
    return [
      for (var i = 0; i < session.faces.length; i++)
        FaceMeshRecord.fromSessionFace(
          session: session,
          face: session.faces[i],
          faceIndex: i,
          uuid: uuid,
          source: source,
          faceGroupId: faceGroupId,
        ),
    ];
  }

  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid!,
      'useYn': useYn,
      'timestamp': timestamp,
      'faceGroupId': faceGroupId,
      if (source != null) 'source': source!,
      if (imagePath != null) 'imagePath': imagePath!,
      if (imageWidth != null) 'imageWidth': imageWidth!,
      if (imageHeight != null) 'imageHeight': imageHeight!,
      if (faceCount != null) 'faceCount': faceCount!,
      if (faceIndex != null) 'faceIndex': faceIndex!,
      if (trackingId != null) 'trackingId': trackingId!,
      if (bboxLeft != null) 'bboxLeft': bboxLeft!,
      if (bboxTop != null) 'bboxTop': bboxTop!,
      if (bboxRight != null) 'bboxRight': bboxRight!,
      if (bboxBottom != null) 'bboxBottom': bboxBottom!,
      if (landmarkCount != null) 'landmarkCount': landmarkCount!,
      if (meshScore != null) 'meshScore': meshScore!,
      if (hasIris != null) 'hasIris': hasIris!,
      if (iodNorm != null) 'iodNorm': iodNorm!,
      if (noseTipX != null) 'noseTipX': noseTipX!,
      if (noseTipY != null) 'noseTipY': noseTipY!,
      if (leftEyeX != null) 'leftEyeX': leftEyeX!,
      if (leftEyeY != null) 'leftEyeY': leftEyeY!,
      if (rightEyeX != null) 'rightEyeX': rightEyeX!,
      if (rightEyeY != null) 'rightEyeY': rightEyeY!,
      if (mouthCenterX != null) 'mouthCenterX': mouthCenterX!,
      if (mouthCenterY != null) 'mouthCenterY': mouthCenterY!,
      if (headEulerX != null) 'headEulerX': headEulerX!,
      if (headEulerY != null) 'headEulerY': headEulerY!,
      if (headEulerZ != null) 'headEulerZ': headEulerZ!,
    };
  }

  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      if (uuid != null && uuid!.isNotEmpty) 'uuid': uuid,
      'useYn': useYn,
      'timestamp': timestamp,
      'faceGroupId': faceGroupId,
      if (source != null) 'source': source,
      if (imagePath != null) 'imagePath': imagePath,
      if (imageWidth != null) 'imageWidth': imageWidth,
      if (imageHeight != null) 'imageHeight': imageHeight,
      if (faceCount != null) 'faceCount': faceCount,
      if (faceIndex != null) 'faceIndex': faceIndex,
      if (trackingId != null) 'trackingId': trackingId,
      if (bboxLeft != null) 'bboxLeft': bboxLeft,
      if (bboxTop != null) 'bboxTop': bboxTop,
      if (bboxRight != null) 'bboxRight': bboxRight,
      if (bboxBottom != null) 'bboxBottom': bboxBottom,
      if (landmarkCount != null) 'landmarkCount': landmarkCount,
      if (meshScore != null) 'meshScore': meshScore,
      if (hasIris != null) 'hasIris': hasIris,
      if (iodNorm != null) 'iodNorm': iodNorm,
      if (noseTipX != null) 'noseTipX': noseTipX,
      if (noseTipY != null) 'noseTipY': noseTipY,
      if (leftEyeX != null) 'leftEyeX': leftEyeX,
      if (leftEyeY != null) 'leftEyeY': leftEyeY,
      if (rightEyeX != null) 'rightEyeX': rightEyeX,
      if (rightEyeY != null) 'rightEyeY': rightEyeY,
      if (mouthCenterX != null) 'mouthCenterX': mouthCenterX,
      if (mouthCenterY != null) 'mouthCenterY': mouthCenterY,
      if (headEulerX != null) 'headEulerX': headEulerX,
      if (headEulerY != null) 'headEulerY': headEulerY,
      if (headEulerZ != null) 'headEulerZ': headEulerZ,
    };
  }
}
