import 'package:egovframe_mobile_deviceapi_app/data/compass/repositories/compass_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/compass/repositories/compass_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/repositories/compass_repository.dart';

class CompassRepositoryImpl implements CompassRepository {
  final CompassRemoteRepositoryImpl _remote;
  final CompassSqliteRepositoryImpl _sqlite;
  final CompassConnectionReader _readConnection;

  CompassRepositoryImpl({
    required CompassRemoteRepositoryImpl remote,
    required CompassSqliteRepositoryImpl sqlite,
    required CompassConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  CompassRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Stream<CompassHeading> watchHeading() => _remote.watchHeading();

  @override
  Future<bool> uploadCompassInfo(CompassInfo info) =>
      _active.uploadCompassInfo(info);

  @override
  Future<List<CompassInfo>> getCompassList() => _active.getCompassList();

  @override
  Future<bool> deleteCompassInfo(CompassInfo info, String deviceUuid) =>
      _active.deleteCompassInfo(info, deviceUuid);
}
