import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/repositories/device_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/device_info_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class DeviceUseCase {
  final DeviceRepository repository;

  DeviceUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  /// 로컬 디바이스 정보 조회
  Future<DeviceLoadResult> loadLocalDeviceInfo() async {
    try {
      final device = await repository.getDeviceInfo();
      return DeviceLoadSuccess(device);
    } catch (e) {
      return DeviceLoadFailure('${DeviceInfoMessageKeys.loadFailedPrefix}$e');
    }
  }

  /// 디바이스 정보 서버 업로드
  Future<DeviceUploadResult> uploadDeviceToServer(DeviceInfo deviceInfo) async {
    if (deviceInfo.uuid.isEmpty) {
      return const DeviceUploadFailure(DeviceInfoMessageKeys.noUploadData);
    }

    try {
      final success = await repository.uploadDeviceInfo(deviceInfo);
      if (success) {
        return const DeviceUploadSuccess();
      }
      return const DeviceUploadFailure(DeviceInfoMessageKeys.uploadFailed);
    } catch (e) {
      return DeviceUploadFailure('${DeviceInfoMessageKeys.uploadErrorPrefix}$e');
    }
  }

  /// 서버 디바이스 목록 조회
  Future<DeviceListLoadResult> loadServerDeviceList(String uuid) async {
    if (!isDeviceUuidValid(uuid)) {
      return const DeviceListLoadFailure(DeviceInfoMessageKeys.uuidRequired);
    }

    try {
      final items = await repository.getDeviceList(uuid);
      if (items.isEmpty) {
        return const DeviceListLoadEmpty();
      }
      return DeviceListLoadSuccess(items);
    } catch (e) {
      return DeviceListLoadFailure('${DeviceInfoMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  /// 서버 디바이스 상세 정보 조회
  Future<DeviceDetailLoadResult> loadDeviceDetail(int sn) async {
    if (sn <= 0) {
      return const DeviceDetailLoadFailure(DeviceInfoMessageKeys.invalidSerial);
    }

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const DeviceDetailLoadFailure(DeviceInfoMessageKeys.uuidRequired);
    }

    try {
      final device = await repository.getDeviceDetail(sn, deviceUuid);
      if (device == null || !deviceBelongsToDevice(device, deviceUuid)) {
        return const DeviceDetailLoadNotFound();
      }
      return DeviceDetailLoadSuccess(device);
    } catch (e) {
      return DeviceDetailLoadFailure('${DeviceInfoMessageKeys.genericErrorPrefix}$e');
    }
  }

  /// 서버 디바이스 정보 삭제
  Future<DeviceDeleteResult> deleteDeviceFromServer(
    int sn, {
    DeviceInfo? device,
  }) async {
    if (sn <= 0) {
      return const DeviceDeleteFailure(DeviceInfoMessageKeys.invalidSerial);
    }

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const DeviceDeleteFailure(DeviceInfoMessageKeys.uuidRequired);
    }

    if (device != null && !deviceBelongsToDevice(device, deviceUuid)) {
      return const DeviceDeleteFailure(DeviceInfoMessageKeys.uuidMismatch);
    }

    try {
      final success = await repository.deleteDevice(sn, deviceUuid);
      if (success) {
        return const DeviceDeleteSuccess();
      }
      return const DeviceDeleteFailure(DeviceInfoMessageKeys.deleteFailed);
    } catch (e) {
      return DeviceDeleteFailure('${DeviceInfoMessageKeys.genericErrorPrefix}$e');
    }
  }
}
