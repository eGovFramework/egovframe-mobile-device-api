import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/media/repositories/media_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/media/repositories/media_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/repositories/media_repository.dart';
import 'package:image_picker/image_picker.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteRepositoryImpl _remote;
  final MediaSqliteRepositoryImpl _sqlite;
  final MediaConnectionReader _readConnection;

  MediaRepositoryImpl({
    required MediaRemoteRepositoryImpl remote,
    required MediaSqliteRepositoryImpl sqlite,
    required MediaConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  MediaRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<XFile?> pickImage(ImageSource source) => _remote.pickImage(source);

  @override
  Future<XFile?> pickVideo(ImageSource source) => _remote.pickVideo(source);

  @override
  Future<String?> saveImageFile(
    XFile imageFile,
    String fileName, {
    ImageSource? captureSource,
  }) =>
      _remote.saveImageFile(
        imageFile,
        fileName,
        captureSource: captureSource,
      );

  @override
  Future<String?> saveVideoFile(
    XFile videoFile,
    String fileName, {
    ImageSource? captureSource,
  }) =>
      _remote.saveVideoFile(
        videoFile,
        fileName,
        captureSource: captureSource,
      );

  @override
  Future<List<MediaFileInfo>> getSavedMediaFiles() =>
      _remote.getSavedMediaFiles();

  @override
  Future<bool> deleteMediaFile(String filePath) =>
      _remote.deleteMediaFile(filePath);

  @override
  Future<Map<String, dynamic>> uploadMediaToServer({
    required List<File> files,
    required String uuid,
  }) =>
      _active.uploadMediaToServer(
        files: files,
        uuid: uuid,
      );

  @override
  Future<List<MediaFileInfo>> getServerMediaList(String uuid) =>
      _active.getServerMediaList(uuid);

  @override
  Future<String> getMediaDownloadUrl(int sn) =>
      _active.getMediaDownloadUrl(sn);

  @override
  Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required ImageSource source,
  }) =>
      _active.pickAndUploadImage(uuid: uuid, source: source);

  @override
  Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required ImageSource source,
  }) =>
      _active.pickAndUploadVideo(uuid: uuid, source: source);

  @override
  Future<Map<String, dynamic>> deleteMediaFromServer(int sn, String uuid) =>
      _active.deleteMediaFromServer(sn, uuid);

  @override
  Future<Map<String, dynamic>> downloadMedia(
    int fileSn,
    String fileName,
    void Function(double) onProgress,
  ) =>
      _active.downloadMedia(fileSn, fileName, onProgress);
}
