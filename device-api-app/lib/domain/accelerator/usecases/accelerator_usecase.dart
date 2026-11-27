import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/repositories/accelerator_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/accelerator_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class AcceleratorUseCase {
  final AcceleratorRepository repository;

  AcceleratorUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  /// 가속도계 정보 목록 조회
  Future<AcceleratorListLoadResult> loadAcceleratorList(String uuid) async {
    if (!isDeviceUuidValid(uuid)) {
      return const AcceleratorListLoadFailure(AcceleratorMessageKeys.noUuid);
    }

    try {
      final items = await repository.getAcceleratorInfoList(uuid);
      if (items.isEmpty) {
        return const AcceleratorListLoadEmpty();
      }
      return AcceleratorListLoadSuccess(items);
    } catch (e) {
      return AcceleratorListLoadFailure(
        '${AcceleratorMessageKeys.listLoadErrorPrefix}$e',
      );
    }
  }

  /// 가속도계 정보 저장
  Future<AcceleratorSaveResult> saveAcceleratorInfo(
    AcceleratorInfo info,
  ) async {
    if (info.uuid.isEmpty) {
      return const AcceleratorSaveFailure(AcceleratorMessageKeys.noUuid);
    }

    try {
      final success = await repository.saveAcceleratorInfo(info);
      if (success) {
        return const AcceleratorSaveSuccess();
      }
      return const AcceleratorSaveFailure(
        AcceleratorMessageKeys.transferFailed,
      );
    } catch (e) {
      return AcceleratorSaveFailure(
        '${AcceleratorMessageKeys.genericErrorPrefix}$e',
      );
    }
  }

  /// 가속도계 정보 단건 삭제
  Future<AcceleratorDeleteResult> deleteAcceleratorFromServer(
    AcceleratorInfo info,
  ) async {
    if (info.sn <= 0) {
      return const AcceleratorDeleteFailure(
        AcceleratorMessageKeys.invalidSerial,
      );
    }

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const AcceleratorDeleteFailure(AcceleratorMessageKeys.noUuid);
    }

    if (!acceleratorBelongsToDevice(info, deviceUuid)) {
      return const AcceleratorDeleteFailure(AcceleratorMessageKeys.uuidMismatch);
    }

    try {
      final success = await repository.deleteAcceleratorInfo(info, deviceUuid);
      if (success) {
        return const AcceleratorDeleteSuccess();
      }
      return const AcceleratorDeleteFailure(
        AcceleratorMessageKeys.deleteFailed,
      );
    } catch (e) {
      return AcceleratorDeleteFailure(
        '${AcceleratorMessageKeys.genericErrorPrefix}$e',
      );
    }
  }
}
