import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/datasources/face_mesh_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';

typedef FaceMeshConnectionReader = FaceMeshConnectionState Function();

/// Face Mesh SQLite 저장소 (persist only)
class FaceMeshSqliteRepositoryImpl {
  final FaceMeshSqliteService _service;
  final FaceMeshConnectionReader _readConnection;

  FaceMeshSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  Future<bool> uploadFaceMeshInfo(FaceMeshRecord info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadFaceMeshInfo(dbFileName, info);
  }

  Future<List<FaceMeshRecord>> getFaceMeshList(
    String deviceUuid,
  ) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getFaceMeshList(dbFileName, deviceUuid);
  }

  Future<bool> deleteFaceMeshInfo(
    FaceMeshRecord info,
    String deviceUuid,
  ) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteFaceMeshInfo(dbFileName, info, deviceUuid);
  }
}
