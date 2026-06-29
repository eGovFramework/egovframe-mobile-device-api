import 'package:egovframe_mobile_deviceapi_app/data/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkService _networkService;

  NetworkRepositoryImpl({NetworkService? networkService})
      : _networkService = networkService ?? NetworkService();

  @override
  Future<bool> sendNetworkInfo(NetworkInfo networkInfo) async {
    return await _networkService.sendNetworkInfoToServer(networkInfo);
  }

  @override
  Future<List<NetworkInfo>> getNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    return await _networkService.getNetworkInfoList(
      uuid: uuid,
      networkType: networkType,
    );
  }

  @override
  Future<bool> deleteNetworkInfo({required String sn, required String uuid}) async {
    return await _networkService.deleteNetworkInfo(sn, uuid: uuid);
  }
}


