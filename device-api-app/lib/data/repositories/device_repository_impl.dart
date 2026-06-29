import 'package:egovframe_mobile_deviceapi_app/data/datasources/device_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    print('=== DeviceInfo 조회 (DeviceService) ===');
    final info = await DeviceService.getDeviceInfo();
    print('DeviceInfo: $info');
    return info;
  }

  @override
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo) async {
    return await DeviceService.uploadDeviceInfo(deviceInfo);
  }

  @override
  Future<List<DeviceInfo>> getDeviceList(String uuid) async {
    final list = await DeviceService.fetchDeviceInfoList(uuid);
    return list;
  }
}
