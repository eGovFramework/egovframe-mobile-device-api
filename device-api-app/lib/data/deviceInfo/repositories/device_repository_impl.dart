import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/repositories/device_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/repositories/device_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteRepositoryImpl _remote;
  final DeviceSqliteRepositoryImpl _sqlite;
  final DeviceConnectionReader _readConnection;

  DeviceRepositoryImpl({
    required DeviceRemoteRepositoryImpl remote,
    required DeviceSqliteRepositoryImpl sqlite,
    required DeviceConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  DeviceRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<DeviceInfo> getDeviceInfo() => _remote.getDeviceInfo();

  @override
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo) =>
      _active.uploadDeviceInfo(deviceInfo);

  @override
  Future<List<DeviceInfo>> getDeviceList(String uuid) =>
      _active.getDeviceList(uuid);

  @override
  Future<DeviceInfo?> getDeviceDetail(int sn, String deviceUuid) =>
      _active.getDeviceDetail(sn, deviceUuid);

  @override
  Future<bool> deleteDevice(int sn, String deviceUuid) =>
      _active.deleteDevice(sn, deviceUuid);
}
