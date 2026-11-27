import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/repositories/network_repository.dart';

class NetworkRemoteRepositoryImpl implements NetworkRepository {
  final NetworkService _networkService;

  NetworkRemoteRepositoryImpl({NetworkService? networkService})
      : _networkService = networkService ?? NetworkService();

  @override
  Future<bool> sendNetworkInfo(NetworkInfo networkInfo) async {
    final body = {
      'uuid': networkInfo.deviceId,
      'sn': '0',
      'networktype': networkInfo.networkType,
      'useYn': networkInfo.useYn,
    };

    final response = await _networkService.insertNetworkInfo(body);
    return _isSuccessResponse(response.statusCode, response.body);
  }

  @override
  Future<List<NetworkInfo>> getNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    final rawList = await _networkService.fetchNetworkInfoList(
      uuid: uuid,
      networkType: networkType,
    );
    final deviceName = await _networkService.getDeviceName();

    return rawList
        .map((item) => _mapToNetworkInfo(item, deviceName))
        .where((item) => networkBelongsToDevice(item, uuid))
        .toList();
  }

  @override
  Future<bool> deleteNetworkInfo({
    required String sn,
    required String uuid,
  }) async {
    final response = await _networkService.deleteNetworkInfoRequest(sn, uuid);
    return _isSuccessResponse(response.statusCode, response.body);
  }

  NetworkInfo _mapToNetworkInfo(
    Map<String, dynamic> map,
    String deviceName,
  ) {
    final networkTypeValue =
        (map['networktype'] ?? map['networkType'] ?? '').toString();
    final uuidValue = (map['uuid'] ?? '').toString();
    final sn = map['sn']?.toString();
    final useYn = (map['useYn'] ?? 'Y').toString();

    return NetworkInfo(
      sn: sn,
      networkType: networkTypeValue,
      networkTypeName: NetworkInfo.getNetworkTypeName(networkTypeValue),
      deviceId: uuidValue,
      deviceName: deviceName,
      useYn: useYn,
      registDate: DateTime.now(),
    );
  }

  bool _isSuccessResponse(int statusCode, String body) {
    if (statusCode != 200) {
      return false;
    }

    try {
      final responseBody = jsonDecode(body) as Map<String, dynamic>;
      final successCode = (responseBody['successCode'] ??
              responseBody['resultState'] ??
              '')
          .toString()
          .toUpperCase();
      return successCode == 'OK';
    } catch (_) {
      return true;
    }
  }
}
