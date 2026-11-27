import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/repositories/network_repository.dart';

typedef NetworkConnectionReader = NetworkConnectionState Function();

class NetworkSqliteRepositoryImpl implements NetworkRepository {
  final NetworkSqliteService _service;
  final NetworkConnectionReader _readConnection;

  NetworkSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<bool> sendNetworkInfo(NetworkInfo networkInfo) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadNetworkInfo(dbFileName, networkInfo);
  }

  @override
  Future<List<NetworkInfo>> getNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    final list = await _service.getNetworkList(
      dbFileName,
      uuid: uuid,
      networkType: networkType,
    );
    return list;
  }

  @override
  Future<bool> deleteNetworkInfo({
    required String sn,
    required String uuid,
  }) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteNetworkInfo(dbFileName, sn: sn, uuid: uuid);
  }
}
