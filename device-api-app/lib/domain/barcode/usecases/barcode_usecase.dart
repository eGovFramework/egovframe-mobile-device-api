import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/repositories/barcode_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/barcode_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class BarcodeUseCase {
  final BarcodeRepository repository;

  BarcodeUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Future<BarcodeUploadResult> uploadBarcodeToServer(BarcodeInfo info) async {
    if (info.codeType.isEmpty || info.codeText.isEmpty) {
      return const BarcodeUploadFailure(BarcodeMessageKeys.noScanData);
    }
    if (!isDeviceUuidValid(info.uuid ?? '')) {
      return const BarcodeUploadFailure(BarcodeMessageKeys.uuidRequired);
    }

    try {
      final success = await repository.uploadBarcodeInfo(info);
      if (success) {
        return const BarcodeUploadSuccess();
      }
      return const BarcodeUploadFailure(BarcodeMessageKeys.uploadFailed);
    } catch (e) {
      return BarcodeUploadFailure('${BarcodeMessageKeys.uploadErrorPrefix}$e');
    }
  }

  Future<BarcodeListLoadResult> loadBarcodeList() async {
    try {
      final deviceUuid = await getDeviceUuid();
      if (!isDeviceUuidValid(deviceUuid)) {
        return const BarcodeListLoadFailure(BarcodeMessageKeys.uuidRequired);
      }

      final items = await repository.getBarcodeList(deviceUuid);
      if (items.isEmpty) {
        return const BarcodeListLoadEmpty();
      }
      return BarcodeListLoadSuccess(items);
    } catch (e) {
      return BarcodeListLoadFailure('${BarcodeMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  Future<BarcodeDeleteBatchResult> deleteBarcodeItems(
    List<BarcodeInfo> items,
  ) async {
    if (items.isEmpty) {
      return const BarcodeDeleteBatchFailure(BarcodeMessageKeys.noSelection);
    }

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const BarcodeDeleteBatchFailure(BarcodeMessageKeys.uuidRequired);
    }

    var deletedCount = 0;
    try {
      for (final item in items) {
        if (!barcodeBelongsToDevice(item, deviceUuid)) {
          return const BarcodeDeleteBatchFailure(BarcodeMessageKeys.uuidMismatch);
        }

        final success = await repository.deleteBarcodeInfo(item, deviceUuid);
        if (!success) {
          return const BarcodeDeleteBatchFailure(BarcodeMessageKeys.deleteFailed);
        }
        deletedCount++;
      }
      return BarcodeDeleteBatchSuccess(deletedCount);
    } catch (e) {
      return BarcodeDeleteBatchFailure('${BarcodeMessageKeys.genericErrorPrefix}$e');
    }
  }
}
