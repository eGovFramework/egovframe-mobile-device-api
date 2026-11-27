import 'package:egovframe_mobile_deviceapi_app/config/face_mesh_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef FaceMeshSqliteSetupStatus = SqliteSetupStatus;

class FaceMeshSqliteService {
  final FeatureTableService _featureTable;

  FaceMeshSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => FaceMeshSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<FaceMeshSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<FaceMeshSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadFaceMeshInfo(
    String fileName,
    FaceMeshRecord info,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (!isDeviceUuidValid(info.uuid ?? '')) return false;

    final sn = await _featureTable.nextMaxIntColumn(
      fileName,
      _schema,
      'sn',
    );

    return _featureTable.insertRow(
      fileName,
      _schema,
      {
        ...info.toSqliteRow(),
        'sn': sn,
        'uuid': info.uuid,
        'useYn': info.useYn,
        'timestamp': info.timestamp,
        'faceGroupId': info.faceGroupId,
      },
    );
  }

  Future<List<FaceMeshRecord>> getFaceMeshList(
    String fileName,
    String deviceUuid,
  ) async {
    if (!isDeviceUuidValid(deviceUuid)) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToRecord)
        .where(
          (item) =>
              item.useYn == 'Y' &&
              faceMeshBelongsToDevice(item, deviceUuid),
        )
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<bool> deleteFaceMeshInfo(
    String fileName,
    FaceMeshRecord info,
    String deviceUuid,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (info.sn <= 0) return false;
    if (!faceMeshBelongsToDevice(info, deviceUuid)) return false;

    // Soft delete: USEYN='N' (contacts 패턴)
    return _featureTable.updateRow(
      fileName,
      _schema,
      {'useYn': 'N'},
      {'sn': info.sn, 'uuid': deviceUuid},
    );
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  FaceMeshRecord _rowToRecord(Map<String, Object?> row) {
    return FaceMeshRecord.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'],
      'useYn': row['useYn'] ?? row['useyn'] ?? row['USEYN'],
      'timestamp': row['timestamp'] ?? row['TIMESTAMP'],
      'faceGroupId':
          row['faceGroupId'] ?? row['face_group_id'] ?? row['FACEGROUPID'],
      'source': row['source'] ?? row['SOURCE'],
      'imagePath': row['imagePath'] ?? row['image_path'] ?? row['IMAGEPATH'],
      'imageWidth':
          row['imageWidth'] ?? row['image_width'] ?? row['IMAGEWIDTH'],
      'imageHeight':
          row['imageHeight'] ?? row['image_height'] ?? row['IMAGEHEIGHT'],
      'faceCount': row['faceCount'] ?? row['face_count'] ?? row['FACECOUNT'],
      'faceIndex': row['faceIndex'] ?? row['face_index'] ?? row['FACEINDEX'],
      'trackingId':
          row['trackingId'] ?? row['tracking_id'] ?? row['TRACKINGID'],
      'bboxLeft': row['bboxLeft'] ?? row['bbox_left'] ?? row['BBOXLEFT'],
      'bboxTop': row['bboxTop'] ?? row['bbox_top'] ?? row['BBOXTOP'],
      'bboxRight': row['bboxRight'] ?? row['bbox_right'] ?? row['BBOXRIGHT'],
      'bboxBottom':
          row['bboxBottom'] ?? row['bbox_bottom'] ?? row['BBOXBOTTOM'],
      'landmarkCount': row['landmarkCount'] ??
          row['landmark_count'] ??
          row['LANDMARKCOUNT'],
      'meshScore':
          row['meshScore'] ?? row['mesh_score'] ?? row['MESHSCORE'],
      'hasIris': row['hasIris'] ?? row['has_iris'] ?? row['HASIRIS'],
      'iodNorm': row['iodNorm'] ?? row['iod_norm'] ?? row['IODNORM'],
      'noseTipX': row['noseTipX'] ?? row['nose_tip_x'] ?? row['NOSETIPX'],
      'noseTipY': row['noseTipY'] ?? row['nose_tip_y'] ?? row['NOSETIPY'],
      'leftEyeX': row['leftEyeX'] ?? row['left_eye_x'] ?? row['LEFTEYEX'],
      'leftEyeY': row['leftEyeY'] ?? row['left_eye_y'] ?? row['LEFTEYEY'],
      'rightEyeX':
          row['rightEyeX'] ?? row['right_eye_x'] ?? row['RIGHTEYEX'],
      'rightEyeY':
          row['rightEyeY'] ?? row['right_eye_y'] ?? row['RIGHTEYEY'],
      'mouthCenterX': row['mouthCenterX'] ??
          row['mouth_center_x'] ??
          row['MOUTHCENTERX'],
      'mouthCenterY': row['mouthCenterY'] ??
          row['mouth_center_y'] ??
          row['MOUTHCENTERY'],
      'headEulerX':
          row['headEulerX'] ?? row['head_euler_x'] ?? row['HEADEULERX'],
      'headEulerY':
          row['headEulerY'] ?? row['head_euler_y'] ?? row['HEADEULERY'],
      'headEulerZ':
          row['headEulerZ'] ?? row['head_euler_z'] ?? row['HEADEULERZ'],
    });
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
