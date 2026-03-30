import 'package:egovframe_mobile_deviceapi_app/domain/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/device_repository.dart';

class DeviceUseCase {
  final DeviceRepository repository;

  DeviceUseCase(this.repository);

  /// 디바이스 정보 조회
  Future<DeviceInfo> getDeviceInfo() async {
    return await repository.getDeviceInfo();
  }

  /// 디바이스 목록 조회
  Future<List<DeviceInfo>> getDeviceList(String uuid) async {
    return await repository.getDeviceList(uuid);
  }

  /// 디바이스 정보 업로드
  Future<bool> uploadDeviceInfo(DeviceInfo deviceInfo) async {
    return await repository.uploadDeviceInfo(deviceInfo);
  }
}
