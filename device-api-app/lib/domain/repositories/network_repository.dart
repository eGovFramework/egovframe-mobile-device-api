import 'package:egovframe_mobile_deviceapi_app/domain/entities/network_info.dart';

abstract class NetworkRepository {
  Future<bool> sendNetworkInfo(NetworkInfo networkInfo);
  Future<List<NetworkInfo>> getNetworkInfoList({required String uuid, String networkType});
  Future<bool> deleteNetworkInfo({required String sn});
}


