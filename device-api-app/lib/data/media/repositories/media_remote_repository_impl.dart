import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/media/datasources/media_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/repositories/media_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:image_picker/image_picker.dart';

class MediaRemoteRepositoryImpl implements MediaRepository {
  MediaRemoteRepositoryImpl();

  @override
  Future<XFile?> pickImage(ImageSource source) async {
    return await MediaService.pickImage(source);
  }

  @override
  Future<XFile?> pickVideo(ImageSource source) async {
    return await MediaService.pickVideo(source);
  }

  @override
  Future<String?> saveImageFile(
    XFile imageFile,
    String fileName, {
    ImageSource? captureSource,
  }) async {
    return await MediaService.saveImageFile(
      imageFile,
      fileName,
      captureSource: captureSource,
    );
  }

  @override
  Future<String?> saveVideoFile(
    XFile videoFile,
    String fileName, {
    ImageSource? captureSource,
  }) async {
    return await MediaService.saveVideoFile(
      videoFile,
      fileName,
      captureSource: captureSource,
    );
  }

  @override
  Future<List<MediaFileInfo>> getSavedMediaFiles() async {
    return await MediaService.getSavedMediaFiles();
  }

  @override
  Future<Map<String, dynamic>> uploadMediaToServer({
    required List<File> files,
    required String uuid,
  }) async {
    return await MediaService.uploadMediaToServer(
      files: files,
      uuid: uuid,
    );
  }

  @override
  Future<List<MediaFileInfo>> getServerMediaList(String uuid) async {
    final response = await MediaService.fetchServerMediaList(uuid);
    if (response.resultState != 'OK') {
      return [];
    }

    final mediaFiles = <MediaFileInfo>[];
    for (final item in response.items) {
      try {
        mediaFiles.add(MediaFileInfo.fromServerApi(item));
      } catch (_) {
        continue;
      }
    }
    return mediaFiles
        .where((item) => mediaBelongsToDevice(item, uuid))
        .toList();
  }

  @override
  Future<String> getMediaDownloadUrl(int sn) async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    return MediaService.getMediaDownloadUrl(sn, uuid: uuid);
  }

  @override
  Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required ImageSource source,
  }) async {
    return await MediaService.pickAndUploadImage(
      uuid: uuid,
      source: source,
    );
  }

  @override
  Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required ImageSource source,
  }) async {
    return await MediaService.pickAndUploadVideo(
      uuid: uuid,
      source: source,
    );
  }

  @override
  Future<Map<String, dynamic>> deleteMediaFromServer(int sn, String uuid) async {
    return await MediaService.deleteMediaFromServer(sn, uuid);
  }

  @override
  Future<bool> deleteMediaFile(String filePath) async {
    return await MediaService.deleteMediaFile(filePath);
  }

  @override
  Future<Map<String, dynamic>> downloadMedia(
    int fileSn,
    String fileName,
    void Function(double) onProgress,
  ) async {
    return await MediaService.downloadMedia(fileSn, fileName, onProgress);
  }
}
