import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/repositories/network_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/network_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class NetworkUseCase {
  final NetworkRepository repository;

  NetworkUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  /// 네트워크 정보를 서버에 전송
  Future<NetworkSendResult> sendNetworkInfo(NetworkInfo networkInfo) async {
    try {
      final success = await repository.sendNetworkInfo(networkInfo);
      if (success) {
        return const NetworkSendSuccess();
      }
      return const NetworkSendFailure(NetworkMessageKeys.sendFailed);
    } catch (e) {
      return NetworkSendFailure('${NetworkMessageKeys.sendErrorPrefix}$e');
    }
  }

  /// 네트워크 정보 목록 조회
  Future<NetworkListLoadResult> loadNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    if (!isDeviceUuidValid(uuid)) {
      return const NetworkListLoadFailure(NetworkMessageKeys.uuidRequired);
    }

    try {
      final items = await repository.getNetworkInfoList(
        uuid: uuid,
        networkType: networkType,
      );
      if (items.isEmpty) {
        return const NetworkListLoadEmpty();
      }
      return NetworkListLoadSuccess(items);
    } catch (e) {
      return NetworkListLoadFailure(
        '${NetworkMessageKeys.listLoadErrorPrefix}$e',
      );
    }
  }

  /// 네트워크 정보 삭제
  Future<NetworkDeleteResult> deleteNetworkInfo({
    required NetworkInfo info,
  }) async {
    if (info.sn == null || info.sn!.isEmpty) {
      return const NetworkDeleteFailure(NetworkMessageKeys.deleteSnMissing);
    }

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const NetworkDeleteFailure(NetworkMessageKeys.uuidRequired);
    }
    if (!networkBelongsToDevice(info, deviceUuid)) {
      return const NetworkDeleteFailure(NetworkMessageKeys.uuidMismatch);
    }

    try {
      final success = await repository.deleteNetworkInfo(
        sn: info.sn!,
        uuid: deviceUuid,
      );
      if (success) {
        return const NetworkDeleteSuccess();
      }
      return const NetworkDeleteFailure(NetworkMessageKeys.deleteFailed);
    } catch (e) {
      return NetworkDeleteFailure('${NetworkMessageKeys.deleteErrorPrefix}$e');
    }
  }

  /// 특정 네트워크 타입의 정보만 조회
  Future<NetworkListLoadResult> getNetworkInfoByType({
    required String uuid,
    required String networkType,
  }) async {
    return loadNetworkInfoList(uuid: uuid, networkType: networkType);
  }

  /// 활성화된 네트워크 정보만 조회
  Future<NetworkListLoadResult> getActiveNetworkInfoList({
    required String uuid,
    String networkType = 'ALL',
  }) async {
    final result = await loadNetworkInfoList(
      uuid: uuid,
      networkType: networkType,
    );

    switch (result) {
      case NetworkListLoadSuccess(:final items):
        final active = items.where((info) => info.useYn == 'Y').toList();
        if (active.isEmpty) {
          return const NetworkListLoadEmpty(NetworkMessageKeys.activeEmpty);
        }
        return NetworkListLoadSuccess(active);
      case NetworkListLoadEmpty():
      case NetworkListLoadFailure():
        return result;
    }
  }

  /// 네트워크 정보 일괄 삭제
  Future<int> deleteMultipleNetworkInfo(List<NetworkInfo> items) async {
    int successCount = 0;
    for (final item in items) {
      final result = await deleteNetworkInfo(info: item);
      if (result is NetworkDeleteSuccess) successCount++;
    }
    return successCount;
  }
}
