import 'package:egovframe_mobile_deviceapi_app/data/accelerator/datasources/accelerometer_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/repositories/accelerator_repository.dart';

class AcceleratorRemoteRepositoryImpl implements AcceleratorRepository {
  AcceleratorRemoteRepositoryImpl();

  @override
  Future<List<AcceleratorInfo>> getAcceleratorInfoList(String uuid) async {
    if (!isDeviceUuidValid(uuid)) return [];

    final rawList = await AccelerometerService.fetchAcceleratorInfoList(uuid);
    return rawList
        .map(AcceleratorInfo.fromJson)
        .where((item) => acceleratorBelongsToDevice(item, uuid))
        .toList();
  }

  @override
  Future<bool> saveAcceleratorInfo(AcceleratorInfo info) async {
    final response =
        await AccelerometerService.postAcceleratorInfo(info.toUploadFields());
    if (response == null) {
      return false;
    }

    return response['resultState'] == 'OK' || response['useYn'] == 'OK';
  }

  @override
  Future<bool> deleteAcceleratorInfo(
    AcceleratorInfo info,
    String deviceUuid,
  ) async {
    if (!acceleratorBelongsToDevice(info, deviceUuid)) {
      return false;
    }

    final response = await AccelerometerService.deleteAcceleratorInfoRequest(
      info.sn,
      deviceUuid,
    );
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}
