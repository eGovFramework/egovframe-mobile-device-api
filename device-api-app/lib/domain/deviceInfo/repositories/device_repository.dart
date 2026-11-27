import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';

abstract class DeviceRepository {
  Future<DeviceInfo> getDeviceInfo();
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo);
  Future<List<DeviceInfo>> getDeviceList(String uuid);
  Future<DeviceInfo?> getDeviceDetail(int sn, String deviceUuid);
  Future<bool> deleteDevice(int sn, String deviceUuid);
}
