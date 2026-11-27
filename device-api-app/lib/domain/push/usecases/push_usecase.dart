import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/repositories/push_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/push_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/push_permission_util.dart';

class PushUseCase {
  final PushRepository repository;

  PushUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Future<PushInitResult> initializeNotifications() async {
    try {
      final permissionGranted =
          await PushPermissionUtil.ensureNotificationPermission();
      if (!permissionGranted) {
        return const PushInitFailure(PushMessageKeys.permissionDenied);
      }

      final success = await repository.initializeNotifications();
      if (success) {
        await repository.collectPushDeviceInfo();
        return const PushInitSuccess();
      }
      return const PushInitFailure(PushMessageKeys.initFailed);
    } catch (e) {
      return PushInitFailure('${PushMessageKeys.initErrorPrefix}$e');
    }
  }

  Future<PushDeviceInfo> collectPushDeviceInfo() =>
      repository.collectPushDeviceInfo();

  Future<bool> isDeviceRegistered(String uuid) =>
      repository.isDeviceRegistered(uuid);

  Future<PushUploadResult> registerPushDevice(PushDeviceInfo info) async {
    if (info.uuid.isEmpty) {
      return const PushUploadFailure(PushMessageKeys.noUuid);
    }
    if (info.tokenId.isEmpty) {
      return const PushUploadFailure(PushMessageKeys.noDeviceData);
    }

    try {
      final success = await repository.registerPushDevice(info);
      if (success) {
        return const PushUploadSuccess();
      }
      return const PushUploadFailure(PushMessageKeys.uploadFailed);
    } catch (e) {
      return PushUploadFailure('${PushMessageKeys.uploadErrorPrefix}$e');
    }
  }

  Future<PushListLoadResult> loadPushMessageList() async {
    try {
      final uuid = await DeviceUuidUtil.getDeviceUuid();
      if (uuid.isEmpty) {
        return const PushListLoadFailure(PushMessageKeys.noUuid);
      }

      final items = await repository.getPushMessageList(uuid);
      final matched = items.where((item) => item.uuid == uuid).toList();
      if (matched.isEmpty) {
        return const PushListLoadEmpty();
      }
      return PushListLoadSuccess(matched);
    } catch (e) {
      return PushListLoadFailure('${PushMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  Future<PushDeleteAllResult> deleteAllPushDevices() async {
    try {
      final success = await repository.deleteAllPushDevices();
      if (success) {
        return const PushDeleteAllSuccess();
      }
      return const PushDeleteAllFailure(PushMessageKeys.deleteFailed);
    } catch (e) {
      return PushDeleteAllFailure('${PushMessageKeys.genericErrorPrefix}$e');
    }
  }
}
