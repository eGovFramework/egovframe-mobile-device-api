import 'package:egovframe_mobile_deviceapi_app/data/push/datasources/push_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/repositories/push_repository.dart';

typedef PushConnectionReader = PushConnectionState Function();

class PushSqliteRepositoryImpl implements PushRepository {
  final PushSqliteService _service;
  final PushConnectionReader _readConnection;

  PushSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<bool> initializeNotifications() {
    throw UnsupportedError('SQLite 모드에서는 푸시 알림 초기화를 사용하지 않습니다.');
  }

  @override
  Future<PushDeviceInfo> collectPushDeviceInfo() {
    throw UnsupportedError('SQLite 모드에서는 푸시 디바이스 정보 수집을 사용하지 않습니다.');
  }

  @override
  Future<bool> registerPushDevice(PushDeviceInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.registerPushDevice(dbFileName, info);
  }

  @override
  Future<bool> isDeviceRegistered(String uuid) async {
    if (uuid.isEmpty) {
      return false;
    }

    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return false;
    }

    final list = await _service.getPushDeviceList(dbFileName);
    return list.any((item) => item.uuid == uuid && item.useYn == 'Y');
  }

  @override
  Future<List<PushMessageInfo>> getPushMessageList(String uuid) {
    throw UnsupportedError('SQLite 모드에서는 푸시 메시지 목록을 사용하지 않습니다.');
  }

  @override
  Future<bool> deleteAllPushDevices() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteAllPushDevices(dbFileName);
  }
}
