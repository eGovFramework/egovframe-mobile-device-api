import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/repositories/media_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/media_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/permission_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaUseCase {
  final MediaRepository repository;

  MediaUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Future<MediaPermissionResult> resolveCameraPermission() async {
    try {
      final status = await PermissionManager.requestCameraPermission();
      return _mapPermissionStatus(status, 'camera');
    } catch (e) {
      return MediaPermissionResult(
        status: MediaPermissionStatus.unknown,
        message: '${MediaMessageKeys.permissionCheckErrorPrefix}camera|$e',
        permissionLabel: 'camera',
      );
    }
  }

  Future<MediaPermissionResult> resolveStoragePermission() async {
    try {
      final status = await PermissionManager.requestStoragePermission();
      return _mapPermissionStatus(status, 'storage');
    } catch (e) {
      return MediaPermissionResult(
        status: MediaPermissionStatus.unknown,
        message: '${MediaMessageKeys.permissionCheckErrorPrefix}storage|$e',
        permissionLabel: 'storage',
      );
    }
  }

  MediaPermissionResult _mapPermissionStatus(
    PermissionStatus status,
    String label,
  ) {
    switch (status) {
      case PermissionStatus.granted:
        return MediaPermissionResult(
          status: MediaPermissionStatus.granted,
          message: '${MediaMessageKeys.permissionGrantedPrefix}$label',
          permissionLabel: label,
        );
      case PermissionStatus.denied:
        return MediaPermissionResult(
          status: MediaPermissionStatus.denied,
          message: PermissionManager.getPermissionMessage(status, label),
          permissionLabel: label,
        );
      case PermissionStatus.permanentlyDenied:
        return MediaPermissionResult(
          status: MediaPermissionStatus.permanentlyDenied,
          message: PermissionManager.getPermissionMessage(status, label),
          permissionLabel: label,
        );
      default:
        return MediaPermissionResult(
          status: MediaPermissionStatus.unknown,
          message: '${MediaMessageKeys.permissionUnknownPrefix}$label',
          permissionLabel: label,
        );
    }
  }

  Future<MediaPermissionResult> resolvePickPermission(ImageSource source) async {
    if (!Platform.isAndroid) {
      return const MediaPermissionResult(
        status: MediaPermissionStatus.granted,
        message: '',
        permissionLabel: '',
      );
    }

    if (source == ImageSource.camera) {
      return resolveCameraPermission();
    }
    return resolveStoragePermission();
  }

  Future<MediaLocalListResult> loadLocalMediaList() async {
    try {
      final items = await repository.getSavedMediaFiles();
      return MediaLocalListSuccess(items);
    } catch (e) {
      return MediaLocalListFailure('${MediaMessageKeys.localListFailedPrefix}$e');
    }
  }

  Future<MediaPickResult> pickImage(ImageSource source) async {
    final permission = await resolvePickPermission(source);
    if (!permission.isGranted && Platform.isAndroid) {
      if (permission.status != MediaPermissionStatus.permanentlyDenied &&
          source != ImageSource.camera) {
        // 저장소는 permanentlyDenied가 아니면 계속 진행
      } else if (!permission.isGranted) {
        return MediaPickPermissionDenied(permission);
      }
    }

    try {
      final file = await repository.pickImage(source);
      if (file == null) {
        if (Platform.isIOS && source == ImageSource.camera) {
          final status = await Permission.camera.status;
          if (status.isPermanentlyDenied) {
            return MediaPickPermissionDenied(
              const MediaPermissionResult(
                status: MediaPermissionStatus.permanentlyDenied,
                message: MediaMessageKeys.cameraPermissionRequired,
                permissionLabel: 'camera',
              ),
            );
          } else if (status.isDenied) {
            return const MediaPickFailure(MediaMessageKeys.cameraPermissionGuide);
          }
        }
        return const MediaPickCancelled();
      }
      return MediaPickSuccess(file);
    } catch (e) {
      return MediaPickFailure('${MediaMessageKeys.imagePickErrorPrefix}$e');
    }
  }

  Future<MediaPickResult> pickVideo(ImageSource source) async {
    final permission = await resolvePickPermission(source);
    if (!permission.isGranted && Platform.isAndroid) {
      if (permission.status != MediaPermissionStatus.permanentlyDenied &&
          source != ImageSource.camera) {
        // 저장소는 permanentlyDenied가 아니면 계속 진행
      } else if (!permission.isGranted) {
        return MediaPickPermissionDenied(permission);
      }
    }

    try {
      final file = await repository.pickVideo(source);
      if (file == null) {
        if (Platform.isIOS && source == ImageSource.camera) {
          final status = await Permission.camera.status;
          if (status.isPermanentlyDenied) {
            return MediaPickPermissionDenied(
              const MediaPermissionResult(
                status: MediaPermissionStatus.permanentlyDenied,
                message: MediaMessageKeys.cameraPermissionRequired,
                permissionLabel: 'camera',
              ),
            );
          } else if (status.isDenied) {
            return const MediaPickFailure(MediaMessageKeys.cameraPermissionGuide);
          }
        }
        return const MediaPickCancelled();
      }
      return MediaPickSuccess(file);
    } catch (e) {
      return MediaPickFailure('${MediaMessageKeys.videoPickErrorPrefix}$e');
    }
  }

  Future<MediaSaveResult> saveImageFile(
    XFile imageFile, {
    ImageSource? captureSource,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = await repository.saveImageFile(
        imageFile,
        fileName,
        captureSource: captureSource,
      );
      if (savedPath == null) {
        return const MediaSaveFailure(MediaMessageKeys.uploadFailed);
      }
      return MediaSaveSuccess(
        savedPath: savedPath,
        message: '${MediaMessageKeys.imageSavedPrefix}$savedPath',
      );
    } catch (e) {
      return MediaSaveFailure('${MediaMessageKeys.imageSaveErrorPrefix}$e');
    }
  }

  Future<MediaSaveResult> saveVideoFile(
    XFile videoFile, {
    ImageSource? captureSource,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      final savedPath = await repository.saveVideoFile(
        videoFile,
        fileName,
        captureSource: captureSource,
      );
      if (savedPath == null) {
        return const MediaSaveFailure(MediaMessageKeys.uploadFailed);
      }
      return MediaSaveSuccess(
        savedPath: savedPath,
        message: '${MediaMessageKeys.videoSavedPrefix}$savedPath',
      );
    } catch (e) {
      return MediaSaveFailure('${MediaMessageKeys.videoSaveErrorPrefix}$e');
    }
  }

  Future<MediaUploadResult> uploadFiles({
    required List<File> files,
    required String uuid,
  }) async {
    if (files.isEmpty) {
      return const MediaUploadFailure(MediaMessageKeys.noValidFilesToUpload);
    }
    if (uuid.isEmpty) {
      return const MediaUploadFailure(MediaMessageKeys.noDeviceUuid);
    }

    try {
      final result = await repository.uploadMediaToServer(
        files: files,
        uuid: uuid,
      );

      if (result['success'] == true) {
        final successCount = _parseCount(result, 'successCount', files.length);
        final failCount = _parseCount(result, 'failCount', 0);
        final message = '${MediaMessageKeys.uploadSummaryPrefix}$successCount|$failCount';
        return MediaUploadSuccess(
          successCount: successCount,
          failCount: failCount,
          message: message,
        );
      }

      final message = result['resultMessage'] ?? result['message'] ?? '';
      return MediaUploadFailure('${MediaMessageKeys.uploadErrorPrefix}$message');
    } catch (e) {
      return MediaUploadFailure('${MediaMessageKeys.uploadErrorPrefix}$e');
    }
  }

  int _parseCount(
    Map<String, dynamic> result,
    String key,
    int fallback,
  ) {
    final value = result[key];
    if (value == null) {
      if (key == 'successCount' && result['fileSn'] != null) return 1;
      final fileResults = result['fileResults'] as List?;
      if (fileResults != null && key == 'successCount') {
        return fileResults.where((r) => r['status'] == 'SUCCESS').length;
      }
      if (fileResults != null && key == 'failCount') {
        return fileResults.where((r) => r['status'] == 'FAIL').length;
      }
      return fallback;
    }
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return (value as num?)?.toInt() ?? fallback;
  }

  Future<MediaDeleteBatchResult> deleteSelectedFiles({
    required Set<String> selectedPaths,
    required List<MediaFileInfo> mediaFiles,
  }) async {
    if (selectedPaths.isEmpty) {
      return const MediaDeleteBatchFailure(MediaMessageKeys.noFilesToDelete);
    }

    final serverFiles = <MediaFileInfo>[];
    final localFilePaths = <String>[];

    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const MediaDeleteBatchFailure(MediaMessageKeys.uuidRequired);
    }

    for (final filePath in selectedPaths) {
      MediaFileInfo? selectedFile;
      for (final file in mediaFiles) {
        if (file.path == filePath) {
          selectedFile = file;
          break;
        }
      }

      if (selectedFile != null &&
          selectedFile.serverSn != null &&
          selectedFile.serverSn! > 0) {
        if (!mediaBelongsToDevice(selectedFile, deviceUuid)) {
          return const MediaDeleteBatchFailure(MediaMessageKeys.uuidMismatch);
        }
        serverFiles.add(selectedFile);
      } else {
        localFilePaths.add(filePath);
      }
    }

    var totalSuccessCount = 0;
    var totalFailCount = 0;

    for (final file in serverFiles) {
      try {
        final sn = int.tryParse(file.sn ?? '') ?? file.serverSn ?? 0;
        final result = await repository.deleteMediaFromServer(sn, deviceUuid);
        if (result['success'] == true) {
          totalSuccessCount++;
          for (final filePath in selectedPaths) {
            try {
              await repository.deleteMediaFile(filePath);
            } catch (_) {}
          }
        } else {
          totalFailCount++;
        }
      } catch (_) {
        totalFailCount++;
      }
    }

    for (final filePath in localFilePaths) {
      try {
        final success = await repository.deleteMediaFile(filePath);
        if (success) {
          totalSuccessCount++;
        } else {
          totalFailCount++;
        }
      } catch (_) {
        totalFailCount++;
      }
    }

    return MediaDeleteBatchSuccess(
      successCount: totalSuccessCount,
      failCount: totalFailCount,
      message:
          '${MediaMessageKeys.deleteSummaryPrefix}$totalSuccessCount|$totalFailCount',
    );
  }

  Future<MediaServerListResult> loadServerMediaList(String deviceUuid) async {
    if (!isDeviceUuidValid(deviceUuid)) {
      return const MediaServerListFailure(MediaMessageKeys.uuidRequired);
    }

    try {
      final items = await repository.getServerMediaList(deviceUuid);
      if (items.isEmpty) {
        return const MediaServerListEmpty();
      }
      return MediaServerListSuccess(items);
    } catch (e) {
      return _mapServerListError(e);
    }
  }

  MediaServerListFailure _mapServerListError(Object e) {
    return MediaServerListFailure('${MediaMessageKeys.serverListFailedPrefix}$e');
  }

  Future<MediaDownloadResult> downloadMedia(
    int fileSn,
    String fileName,
    void Function(double) onProgress,
  ) async {
    try {
      final result =
          await repository.downloadMedia(fileSn, fileName, onProgress);
      if (result['success'] == true) {
        return const MediaDownloadSuccess();
      }
      return const MediaDownloadFailure(MediaMessageKeys.downloadFailed);
    } catch (e) {
      return MediaDownloadFailure('${MediaMessageKeys.downloadFailedPrefix}$e');
    }
  }

  Future<MediaServerDeleteResult> deleteMediaFromServer(
    MediaFileInfo mediaFile,
  ) async {
    final deviceUuid = await getDeviceUuid();
    if (!isDeviceUuidValid(deviceUuid)) {
      return const MediaServerDeleteFailure(MediaMessageKeys.uuidRequired);
    }
    if (!mediaBelongsToDevice(mediaFile, deviceUuid)) {
      return const MediaServerDeleteFailure(MediaMessageKeys.uuidMismatch);
    }

    final sn = int.tryParse(mediaFile.sn ?? '') ?? mediaFile.serverSn ?? 0;

    try {
      final result = await repository.deleteMediaFromServer(sn, deviceUuid);
      if (result['success'] == true) {
        return const MediaServerDeleteSuccess();
      }
      return MediaServerDeleteFailure(
        '${MediaMessageKeys.serverDeleteFailedPrefix}${result['message']}',
      );
    } catch (e) {
      return MediaServerDeleteFailure(
        '${MediaMessageKeys.serverDeleteErrorPrefix}$e',
      );
    }
  }

  Future<MediaDownloadUrlResult> getMediaDownloadUrl(int sn) async {
    try {
      final url = await repository.getMediaDownloadUrl(sn);
      return MediaDownloadUrlSuccess(url);
    } catch (e) {
      return MediaDownloadUrlFailure('${MediaMessageKeys.downloadUrlErrorPrefix}$e');
    }
  }
}
