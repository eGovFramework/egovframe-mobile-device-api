import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/datasources/device_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/repositories/device_repository.dart';

class DeviceRemoteRepositoryImpl implements DeviceRepository {
  DeviceRemoteRepositoryImpl();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    final raw = await DeviceService.collectLocalDeviceInfo();
    return DeviceInfo.fromJson(raw);
  }

  @override
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo) async {
    final response =
        await DeviceService.postDeviceInfo(deviceInfo.toUploadFields());
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    if (resultState == 'OK') {
      return true;
    }

    final deviceVO = response['deviceAPIVO'] as Map<String, dynamic>?;
    if (deviceVO != null) {
      final useYn = (deviceVO['useYn'] ?? '').toString();
      return useYn == 'OK';
    }

    return false;
  }

  @override
  Future<List<DeviceInfo>> getDeviceList(String uuid) async {
    if (!isDeviceUuidValid(uuid)) return [];

    final rawList = await DeviceService.fetchDeviceInfoList(uuid);
    return rawList
        .map(DeviceInfo.fromJson)
        .where((item) => deviceBelongsToDevice(item, uuid))
        .toList();
  }

  @override
  Future<DeviceInfo?> getDeviceDetail(int sn, String deviceUuid) async {
    if (!isDeviceUuidValid(deviceUuid)) return null;

    final raw = await DeviceService.fetchDeviceInfoDetail(sn, deviceUuid);
    if (raw == null) {
      return null;
    }

    final device = DeviceInfo.fromJson(raw);
    if (!deviceBelongsToDevice(device, deviceUuid)) {
      return null;
    }
    return device;
  }

  @override
  Future<bool> deleteDevice(int sn, String deviceUuid) async {
    if (!isDeviceUuidValid(deviceUuid)) return false;

    final response = await DeviceService.deleteDeviceInfoRequest(
      sn,
      deviceUuid,
    );
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}
