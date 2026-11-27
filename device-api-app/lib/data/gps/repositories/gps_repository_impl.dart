import 'package:egovframe_mobile_deviceapi_app/data/gps/repositories/gps_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/gps/repositories/gps_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/repositories/gps_repository.dart';

class GpsRepositoryImpl implements GpsRepository {
  final GpsRemoteRepositoryImpl _remote;
  final GpsSqliteRepositoryImpl _sqlite;
  final GpsConnectionReader _readConnection;

  GpsRepositoryImpl({
    required GpsRemoteRepositoryImpl remote,
    required GpsSqliteRepositoryImpl sqlite,
    required GpsConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  GpsRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<GpsInfo?> getCurrentLocation() => _remote.getCurrentLocation();

  @override
  Future<bool> saveGpsInfo(GpsInfo gpsInfo) => _active.saveGpsInfo(gpsInfo);

  @override
  Future<List<GpsInfo>> getGpsInfoList(String uuid) =>
      _active.getGpsInfoList(uuid);

  @override
  Future<bool> deleteGpsInfo(GpsInfo info, String deviceUuid) =>
      _active.deleteGpsInfo(info, deviceUuid);
}
