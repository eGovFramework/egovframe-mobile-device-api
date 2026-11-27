import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/datasources/device_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/repositories/device_repository.dart';

typedef DeviceConnectionReader = DeviceConnectionState Function();

class DeviceSqliteRepositoryImpl implements DeviceRepository {
  final DeviceSqliteService _service;
  final DeviceConnectionReader _readConnection;

  DeviceSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<DeviceInfo> getDeviceInfo() {
    throw UnsupportedError('SQLite 모드에서는 로컬 디바이스 정보 수집을 사용하지 않습니다.');
  }

  @override
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadDeviceInfo(dbFileName, deviceInfo);
  }

  @override
  Future<List<DeviceInfo>> getDeviceList(String uuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getDeviceList(dbFileName, uuid);
  }

  @override
  Future<DeviceInfo?> getDeviceDetail(int sn, String deviceUuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return null;
    return _service.getDeviceDetail(dbFileName, sn, deviceUuid);
  }

  @override
  Future<bool> deleteDevice(int sn, String deviceUuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteDevice(dbFileName, sn, deviceUuid);
  }
}
