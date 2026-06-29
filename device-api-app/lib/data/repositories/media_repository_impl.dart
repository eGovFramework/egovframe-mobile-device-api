import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/datasources/media_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/media_repository.dart';
import 'package:image_picker/image_picker.dart';

class MediaRepositoryImpl implements MediaRepository {
  MediaRepositoryImpl();

  @override
  Future<XFile?> pickImage(ImageSource source) async {
    return await MediaService.pickImage(source);
  }

  @override
  Future<XFile?> pickVideo(ImageSource source) async {
    return await MediaService.pickVideo(source);
  }

  @override
  Future<String?> saveImageFile(XFile imageFile, String fileName) async {
    return await MediaService.saveImageFile(imageFile, fileName);
  }

  @override
  Future<String?> saveVideoFile(XFile videoFile, String fileName) async {
    return await MediaService.saveVideoFile(videoFile, fileName);
  }

  @override
  Future<List<MediaFileInfo>> getSavedMediaFiles() async {
    return await MediaService.getSavedMediaFiles();
  }

  @override
  Future<Map<String, dynamic>> uploadMediaToServer({
    required List<File> files,
    required String uuid,
    required int startSn,
  }) async {
    return await MediaService.uploadMediaToServer(
      files: files,
      uuid: uuid,
      startSn: startSn,
    );
  }

  @override
  Future<List<MediaFileInfo>> getServerMediaList(String uuid) async {
    return await MediaService.getServerMediaList(uuid);
  }

  @override
  Future<String> getMediaDownloadUrl(int sn) async {
    return MediaService.getMediaDownloadUrl(sn);
  }

  @override
  Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required int sn,
    required ImageSource source,
  }) async {
    return await MediaService.pickAndUploadImage(
      uuid: uuid,
      sn: sn,
      source: source,
    );
  }

  @override
  Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required int sn,
    required ImageSource source,
  }) async {
    return await MediaService.pickAndUploadVideo(
      uuid: uuid,
      sn: sn,
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
}

