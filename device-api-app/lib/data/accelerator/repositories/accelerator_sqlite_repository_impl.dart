import 'package:egovframe_mobile_deviceapi_app/data/accelerator/datasources/accelerator_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/repositories/accelerator_repository.dart';

typedef AcceleratorConnectionReader = AcceleratorConnectionState Function();

class AcceleratorSqliteRepositoryImpl implements AcceleratorRepository {
  final AcceleratorSqliteService _service;
  final AcceleratorConnectionReader _readConnection;

  AcceleratorSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<List<AcceleratorInfo>> getAcceleratorInfoList(String uuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getAcceleratorList(dbFileName, uuid);
  }

  @override
  Future<bool> saveAcceleratorInfo(AcceleratorInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadAcceleratorInfo(dbFileName, info);
  }

  @override
  Future<bool> deleteAcceleratorInfo(
    AcceleratorInfo info,
    String deviceUuid,
  ) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteAcceleratorInfo(dbFileName, info, deviceUuid);
  }
}
