import 'package:egovframe_mobile_deviceapi_app/data/gps/datasources/gps_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/repositories/gps_repository.dart';

typedef GpsConnectionReader = GpsConnectionState Function();

class GpsSqliteRepositoryImpl implements GpsRepository {
  final GpsSqliteService _service;
  final GpsConnectionReader _readConnection;

  GpsSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<GpsInfo?> getCurrentLocation() {
    throw UnsupportedError('SQLite 모드에서는 로컬 GPS 위치 조회를 사용하지 않습니다.');
  }

  @override
  Future<bool> saveGpsInfo(GpsInfo gpsInfo) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadGpsInfo(dbFileName, gpsInfo);
  }

  @override
  Future<List<GpsInfo>> getGpsInfoList(String uuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    final list = await _service.getGpsList(dbFileName);
    if (uuid.isEmpty) return list;
    return list.where((item) => item.uuid == uuid).toList();
  }

  @override
  Future<bool> deleteGpsInfo(GpsInfo info, String deviceUuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteGpsInfo(dbFileName, info, deviceUuid);
  }
}
