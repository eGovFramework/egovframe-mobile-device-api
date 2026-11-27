import 'package:egovframe_mobile_deviceapi_app/data/network/repositories/network_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/repositories/network_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkRemoteRepositoryImpl _remote;
  final NetworkSqliteRepositoryImpl _sqlite;
  final NetworkConnectionReader _readConnection;

  NetworkRepositoryImpl({
    required NetworkRemoteRepositoryImpl remote,
    required NetworkSqliteRepositoryImpl sqlite,
    required NetworkConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  NetworkRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<bool> sendNetworkInfo(NetworkInfo networkInfo) =>
      _active.sendNetworkInfo(networkInfo);

  @override
  Future<List<NetworkInfo>> getNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) =>
      _active.getNetworkInfoList(uuid: uuid, networkType: networkType);

  @override
  Future<bool> deleteNetworkInfo({
    required String sn,
    required String uuid,
  }) =>
      _active.deleteNetworkInfo(sn: sn, uuid: uuid);
}
