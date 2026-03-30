import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:image_picker/image_picker.dart';

abstract class MediaRepository {
  Future<XFile?> pickImage(ImageSource source);
  Future<XFile?> pickVideo(ImageSource source);
  Future<String?> saveImageFile(XFile imageFile, String fileName);
  Future<String?> saveVideoFile(XFile videoFile, String fileName);
  Future<List<MediaFileInfo>> getSavedMediaFiles();
  Future<Map<String, dynamic>> uploadMediaToServer({
    required List<File> files,
    required String uuid,
    required int startSn,
  });
  // Future<Map<String, dynamic>> getMediaInfoDetail(int sn);
  Future<List<MediaFileInfo>> getServerMediaList(String uuid);
  Future<String> getMediaDownloadUrl(int sn);
  Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required int sn,
    required ImageSource source,
  });
  Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required int sn,
    required ImageSource source,
  });
  Future<Map<String, dynamic>> deleteMediaFromServer(int sn);
  Future<bool> deleteMediaFile(String filePath);
}

