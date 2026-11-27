import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/repositories/compass_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/compass_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class CompassUseCase {
  final CompassRepository repository;

  CompassUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Stream<CompassHeading> watchHeading() => repository.watchHeading();

  Future<CompassUploadResult> uploadCompassToServer(CompassInfo info) async {
    if (info.uuid.isEmpty) {
      return const CompassUploadFailure(CompassMessageKeys.noUuid);
    }
    if (info.drc.isEmpty) {
      return const CompassUploadFailure(CompassMessageKeys.noHeadingData);
    }

    try {
      final success = await repository.uploadCompassInfo(info);
      if (success) {
        return const CompassUploadSuccess();
      }
      return const CompassUploadFailure(CompassMessageKeys.uploadFailed);
    } catch (e) {
      return CompassUploadFailure('${CompassMessageKeys.uploadErrorPrefix}$e');
    }
  }

  Future<CompassListLoadResult> loadCompassList() async {
    try {
      final items = await repository.getCompassList();
      if (items.isEmpty) {
        return const CompassListLoadEmpty();
      }
      return CompassListLoadSuccess(items);
    } catch (e) {
      return CompassListLoadFailure('${CompassMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  Future<CompassDeleteBatchResult> deleteCompassItems(
    List<CompassInfo> items,
  ) async {
    if (items.isEmpty) {
      return const CompassDeleteBatchFailure(CompassMessageKeys.noSelection);
    }

    final deviceUuid = await getDeviceUuid();
    if (deviceUuid.isEmpty) {
      return const CompassDeleteBatchFailure(CompassMessageKeys.noUuid);
    }

    var deletedCount = 0;
    try {
      for (final item in items) {
        if (item.uuid.isEmpty || item.uuid != deviceUuid) {
          return const CompassDeleteBatchFailure(CompassMessageKeys.noUuid);
        }

        final success = await repository.deleteCompassInfo(item, deviceUuid);
        if (!success) {
          return const CompassDeleteBatchFailure(CompassMessageKeys.deleteFailed);
        }
        deletedCount++;
      }
      return CompassDeleteBatchSuccess(deletedCount);
    } catch (e) {
      return CompassDeleteBatchFailure(
        '${CompassMessageKeys.genericErrorPrefix}$e',
      );
    }
  }
}
