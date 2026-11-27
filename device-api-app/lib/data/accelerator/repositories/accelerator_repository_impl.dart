import 'package:egovframe_mobile_deviceapi_app/data/accelerator/repositories/accelerator_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/accelerator/repositories/accelerator_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/repositories/accelerator_repository.dart';

class AcceleratorRepositoryImpl implements AcceleratorRepository {
  final AcceleratorRemoteRepositoryImpl _remote;
  final AcceleratorSqliteRepositoryImpl _sqlite;
  final AcceleratorConnectionReader _readConnection;

  AcceleratorRepositoryImpl({
    required AcceleratorRemoteRepositoryImpl remote,
    required AcceleratorSqliteRepositoryImpl sqlite,
    required AcceleratorConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  AcceleratorRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<List<AcceleratorInfo>> getAcceleratorInfoList(String uuid) =>
      _active.getAcceleratorInfoList(uuid);

  @override
  Future<bool> saveAcceleratorInfo(AcceleratorInfo info) =>
      _active.saveAcceleratorInfo(info);

  @override
  Future<bool> deleteAcceleratorInfo(
    AcceleratorInfo info,
    String deviceUuid,
  ) =>
      _active.deleteAcceleratorInfo(info, deviceUuid);
}
