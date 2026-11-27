import 'package:egovframe_mobile_deviceapi_app/data/push/repositories/push_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/push/repositories/push_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/repositories/push_repository.dart';class PushRepositoryImpl implements PushRepository {
  final PushRemoteRepositoryImpl _remote;
  final PushSqliteRepositoryImpl _sqlite;
  final PushConnectionReader _readConnection;

  PushRepositoryImpl({
    required PushRemoteRepositoryImpl remote,
    required PushSqliteRepositoryImpl sqlite,
    required PushConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  PushRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<bool> initializeNotifications() => _remote.initializeNotifications();

  @override
  Future<PushDeviceInfo> collectPushDeviceInfo() =>
      _remote.collectPushDeviceInfo();

  @override
  Future<bool> registerPushDevice(PushDeviceInfo info) =>
      _active.registerPushDevice(info);

  @override
  Future<bool> isDeviceRegistered(String uuid) =>
      _active.isDeviceRegistered(uuid);

  @override
  Future<List<PushMessageInfo>> getPushMessageList(String uuid) =>
      _remote.getPushMessageList(uuid);
  @override
  Future<bool> deleteAllPushDevices() => _active.deleteAllPushDevices();
}
