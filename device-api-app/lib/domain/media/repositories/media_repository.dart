import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:image_picker/image_picker.dart';

abstract class MediaRepository {
  Future<XFile?> pickImage(ImageSource source);
  Future<XFile?> pickVideo(ImageSource source);
  Future<String?> saveImageFile(
    XFile imageFile,
    String fileName, {
    ImageSource? captureSource,
  });
  Future<String?> saveVideoFile(
    XFile videoFile,
    String fileName, {
    ImageSource? captureSource,
  });
  Future<List<MediaFileInfo>> getSavedMediaFiles();
  Future<Map<String, dynamic>> uploadMediaToServer({
    required List<File> files,
    required String uuid,
  });
  // Future<Map<String, dynamic>> getMediaInfoDetail(int sn);
  Future<List<MediaFileInfo>> getServerMediaList(String uuid);
  Future<String> getMediaDownloadUrl(int sn);
  Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required ImageSource source,
  });
  Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required ImageSource source,
  });
  Future<Map<String, dynamic>> deleteMediaFromServer(int sn, String uuid);
  Future<bool> deleteMediaFile(String filePath);
  Future<Map<String, dynamic>> downloadMedia(
    int fileSn,
    String fileName,
    void Function(double) onProgress,
  );
}

