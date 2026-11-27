import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Face Mesh SQLite 연동 스키마 (MySQL face_mesh_INFO 테이블과 동일 컬럼)
class FaceMeshSqliteSchema {
  FaceMeshSqliteSchema._();

  static const String tableName = AppConfig.faceMeshTableName;

  static const Set<String> requiredColumns = {
    'faceGroupId',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'uuid',
    'timestamp',
    'source',
    'imagePath',
    'imageWidth',
    'imageHeight',
    'faceCount',
    'faceIndex',
    'trackingId',
    'bboxLeft',
    'bboxTop',
    'bboxRight',
    'bboxBottom',
    'landmarkCount',
    'meshScore',
    'hasIris',
    'iodNorm',
    'noseTipX',
    'noseTipY',
    'leftEyeX',
    'leftEyeY',
    'rightEyeX',
    'rightEyeY',
    'mouthCenterX',
    'mouthCenterY',
    'headEulerX',
    'headEulerY',
    'headEulerZ',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'face_mesh_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
