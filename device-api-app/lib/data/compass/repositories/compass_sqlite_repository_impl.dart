import 'package:egovframe_mobile_deviceapi_app/data/compass/datasources/compass_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/repositories/compass_repository.dart';

typedef CompassConnectionReader = CompassConnectionState Function();

class CompassSqliteRepositoryImpl implements CompassRepository {
  final CompassSqliteService _service;
  final CompassConnectionReader _readConnection;

  CompassSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Stream<CompassHeading> watchHeading() {
    throw UnsupportedError('SQLite 모드에서는 나침반 센서 스트림을 사용하지 않습니다.');
  }

  @override
  Future<bool> uploadCompassInfo(CompassInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadCompassInfo(dbFileName, info);
  }

  @override
  Future<List<CompassInfo>> getCompassList() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getCompassList(dbFileName);
  }

  @override
  Future<bool> deleteCompassInfo(CompassInfo info, String deviceUuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteCompassInfo(dbFileName, info, deviceUuid);
  }
}
