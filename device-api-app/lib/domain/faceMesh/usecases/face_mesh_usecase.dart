import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/repositories/face_mesh_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/face_mesh_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:image_picker/image_picker.dart';

class FaceMeshUseCase {
  final FaceMeshRepository repository;

  FaceMeshUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Future<FaceMeshPickResult> pickAndDetect(ImageSource source) {
    return repository.pickAndDetect(source);
  }

  Future<FaceMeshProcessResult> detectFromFile(
    String imagePath, {
    String? source,
  }) {
    return repository.detectFromFile(imagePath, source: source);
  }

  Future<List<DetectedFaceMeshInfo>> detectFromCameraFrame({
    required List<int> bytes,
    required int width,
    required int height,
    required int rotationDegrees,
    required int bytesPerRow,
    required String formatRaw,
    bool enrichAttributes = false,
  }) {
    return repository.detectFromInputImageBytes(
      bytes: bytes,
      width: width,
      height: height,
      rotationDegrees: rotationDegrees,
      bytesPerRow: bytesPerRow,
      formatRaw: formatRaw,
      enrichAttributes: enrichAttributes,
    );
  }

  Future<FaceMeshUploadResult> uploadSessionToStore(
    FaceMeshSession session, {
    String? source,
  }) async {
    if (!session.hasFaces) {
      return const FaceMeshUploadFailure(
        FaceMeshMessageKeys.noDetectionData,
      );
    }

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const FaceMeshUploadFailure(
        FaceMeshMessageKeys.uuidRequired,
      );
    }

    final effectiveSource = source ?? session.source ?? 'gallery';
    final faceGroupId = 'fg-${DateTime.now().millisecondsSinceEpoch}';
    final records = FaceMeshRecord.fromSession(
      session,
      uuid: deviceUuid,
      source: effectiveSource,
      faceGroupId: faceGroupId,
    );

    try {
      for (final record in records) {
        final success = await repository.uploadFaceMeshInfo(record);
        if (!success) {
          return const FaceMeshUploadFailure(
            FaceMeshMessageKeys.uploadFailed,
          );
        }
      }
      return const FaceMeshUploadSuccess();
    } catch (e) {
      return FaceMeshUploadFailure(
        '${FaceMeshMessageKeys.uploadErrorPrefix}$e',
      );
    }
  }

  Future<FaceMeshUploadResult> uploadRecord(
    FaceMeshRecord info,
  ) async {
    if (info.faceGroupId.isEmpty) {
      return const FaceMeshUploadFailure(
        FaceMeshMessageKeys.noDetectionData,
      );
    }
    if (!isDeviceUuidValid(info.uuid ?? '')) {
      return const FaceMeshUploadFailure(
        FaceMeshMessageKeys.uuidRequired,
      );
    }

    try {
      final success = await repository.uploadFaceMeshInfo(info);
      if (success) {
        return const FaceMeshUploadSuccess();
      }
      return const FaceMeshUploadFailure(
        FaceMeshMessageKeys.uploadFailed,
      );
    } catch (e) {
      return FaceMeshUploadFailure(
        '${FaceMeshMessageKeys.uploadErrorPrefix}$e',
      );
    }
  }

  Future<FaceMeshListLoadResult> loadList() async {
    try {
      final deviceUuid = await getDeviceUuid();
      if (!isDeviceUuidValid(deviceUuid)) {
        return const FaceMeshListLoadFailure(
          FaceMeshMessageKeys.uuidRequired,
        );
      }

      final items = await repository.getFaceMeshList(deviceUuid);
      if (items.isEmpty) {
        return const FaceMeshListLoadEmpty();
      }
      return FaceMeshListLoadSuccess(items);
    } catch (e) {
      return FaceMeshListLoadFailure(
        '${FaceMeshMessageKeys.listLoadErrorPrefix}$e',
      );
    }
  }

  Future<FaceMeshDeleteBatchResult> deleteItems(
    List<FaceMeshRecord> items,
  ) async {
    if (items.isEmpty) {
      return const FaceMeshDeleteBatchFailure(
        FaceMeshMessageKeys.noSelection,
      );
    }

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const FaceMeshDeleteBatchFailure(
        FaceMeshMessageKeys.uuidRequired,
      );
    }

    var deletedCount = 0;
    try {
      for (final item in items) {
        if (!faceMeshBelongsToDevice(item, deviceUuid)) {
          return const FaceMeshDeleteBatchFailure(
            FaceMeshMessageKeys.uuidMismatch,
          );
        }

        final success =
            await repository.deleteFaceMeshInfo(item, deviceUuid);
        if (!success) {
          return const FaceMeshDeleteBatchFailure(
            FaceMeshMessageKeys.deleteFailed,
          );
        }
        deletedCount++;
      }
      return FaceMeshDeleteBatchSuccess(deletedCount);
    } catch (e) {
      return FaceMeshDeleteBatchFailure(
        '${FaceMeshMessageKeys.genericErrorPrefix}$e',
      );
    }
  }
}
