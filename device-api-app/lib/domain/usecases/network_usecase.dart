import 'package:egovframe_mobile_deviceapi_app/domain/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/network_repository.dart';

class NetworkUseCase {
  final NetworkRepository repository;

  NetworkUseCase(this.repository);

  /// 네트워크 정보를 서버에 전송
  Future<bool> sendNetworkInfo(NetworkInfo networkInfo) async {
    return await repository.sendNetworkInfo(networkInfo);
  }

  /// 네트워크 정보 목록 조회
  Future<List<NetworkInfo>> getNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    return await repository.getNetworkInfoList(
      uuid: uuid,
      networkType: networkType,
    );
  }

  /// 네트워크 정보 삭제
  Future<bool> deleteNetworkInfo({required String sn, required String uuid}) async {
    return await repository.deleteNetworkInfo(sn: sn, uuid: uuid);
  }

  /// 특정 네트워크 타입의 정보만 조회
  Future<List<NetworkInfo>> getNetworkInfoByType({
    required String uuid,
    required String networkType,
  }) async {
    return await repository.getNetworkInfoList(
      uuid: uuid,
      networkType: networkType,
    );
  }

  /// 활성화된 네트워크 정보만 조회
  Future<List<NetworkInfo>> getActiveNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    final allNetworkInfo = await repository.getNetworkInfoList(
      uuid: uuid,
      networkType: networkType,
    );
    
    return allNetworkInfo.where((info) => info.useYn == 'Y').toList();
  }
}

