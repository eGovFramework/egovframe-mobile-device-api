import 'package:egovframe_mobile_deviceapi_app/data/push/datasources/push_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/repositories/push_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class PushRemoteRepositoryImpl implements PushRepository {
  @override
  Future<bool> initializeNotifications() => PushService.initializeNotifications();

  @override
  Future<PushDeviceInfo> collectPushDeviceInfo() =>
      PushService.collectPushDeviceInfo();

  @override
  Future<bool> registerPushDevice(PushDeviceInfo info) async {
    final response = await PushService.postPushDevice(info.toUploadFields());
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    if (resultState == 'OK') {
      return true;
    }

    final useYn = (response['useYn'] ?? '').toString();
    return useYn == 'OK';
  }

  @override
  Future<bool> isDeviceRegistered(String uuid) async {
    if (uuid.isEmpty) {
      return false;
    }

    final rawList = await PushService.fetchPushDeviceList(uuid);
    return rawList.any(
      (item) => (item['uuid'] ?? '').toString() == uuid,
    );
  }

  @override
  Future<List<PushMessageInfo>> getPushMessageList(String uuid) async {
    final rawList = await PushService.fetchPushMessageList(uuid);
    return rawList.map(PushMessageInfo.fromJson).toList();
  }

  @override
  Future<bool> deleteAllPushDevices() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    if (uuid.isEmpty) {
      return false;
    }

    final response = await PushService.deletePushDevice(uuid);
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}
