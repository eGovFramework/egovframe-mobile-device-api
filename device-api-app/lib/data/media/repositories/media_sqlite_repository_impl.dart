import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/media/datasources/media_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/media/datasources/media_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/repositories/media_repository.dart';
import 'package:image_picker/image_picker.dart';

typedef MediaConnectionReader = MediaConnectionState Function();

class MediaSqliteRepositoryImpl implements MediaRepository {
  final MediaSqliteService _service;
  final MediaConnectionReader _readConnection;

  MediaSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<XFile?> pickImage(ImageSource source) {
    throw UnsupportedError('SQLite 모드에서는 로컬 pick을 remote에 위임합니다.');
  }

  @override
  Future<XFile?> pickVideo(ImageSource source) {
    throw UnsupportedError('SQLite 모드에서는 로컬 pick을 remote에 위임합니다.');
  }

  @override
  Future<String?> saveImageFile(
    XFile imageFile,
    String fileName, {
    ImageSource? captureSource,
  }) {
    throw UnsupportedError('SQLite 모드에서는 로컬 저장을 remote에 위임합니다.');
  }

  @override
  Future<String?> saveVideoFile(
    XFile videoFile,
    String fileName, {
    ImageSource? captureSource,
  }) {
    throw UnsupportedError('SQLite 모드에서는 로컬 저장을 remote에 위임합니다.');
  }

  @override
  Future<List<MediaFileInfo>> getSavedMediaFiles() {
    throw UnsupportedError('SQLite 모드에서는 로컬 목록을 remote에 위임합니다.');
  }

  @override
  Future<bool> deleteMediaFile(String filePath) {
    throw UnsupportedError('SQLite 모드에서는 로컬 파일 삭제를 remote에 위임합니다.');
  }

  @override
  Future<Map<String, dynamic>> uploadMediaToServer({
    required List<File> files,
    required String uuid,
  }) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {
        'success': false,
        'message': 'SQLite DB가 선택되지 않았습니다.',
        'resultState': 'FAIL',
      };
    }
    return _service.uploadMediaToServer(
      fileName: dbFileName,
      files: files,
      uuid: uuid,
    );
  }

  @override
  Future<List<MediaFileInfo>> getServerMediaList(String uuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getServerMediaList(dbFileName, uuid);
  }

  @override
  Future<String> getMediaDownloadUrl(int sn) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      throw UnsupportedError('SQLite DB가 선택되지 않았습니다.');
    }
    final localPath = await _service.resolveLocalPath(dbFileName, sn);
    if (localPath == null) {
      throw UnsupportedError('SQLite 메타데이터에서 로컬 경로를 찾을 수 없습니다.');
    }
    return localPath;
  }

  @override
  Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required ImageSource source,
  }) async {
    try {
      final XFile? imageFile = await MediaService.pickImage(source);
      if (imageFile == null) {
        return {'success': false, 'message': '이미지 선택이 취소되었습니다.'};
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = await MediaService.saveImageFile(
        imageFile,
        fileName,
        captureSource: source,
      );
      if (savedPath == null) {
        return {'success': false, 'message': '이미지 저장에 실패했습니다.'};
      }

      return uploadMediaToServer(
        files: [File(savedPath)],
        uuid: uuid,
      );
    } catch (e) {
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required ImageSource source,
  }) async {
    try {
      final XFile? videoFile = await MediaService.pickVideo(source);
      if (videoFile == null) {
        return {'success': false, 'message': '비디오 선택이 취소되었습니다.'};
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      final savedPath = await MediaService.saveVideoFile(
        videoFile,
        fileName,
        captureSource: source,
      );
      if (savedPath == null) {
        return {'success': false, 'message': '비디오 저장에 실패했습니다.'};
      }

      return uploadMediaToServer(
        files: [File(savedPath)],
        uuid: uuid,
      );
    } catch (e) {
      return {'success': false, 'message': '오류가 발생했습니다: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteMediaFromServer(int sn, String uuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {
        'success': false,
        'message': 'SQLite DB가 선택되지 않았습니다.',
        'resultState': 'FAIL',
      };
    }
    return _service.deleteMediaFromServer(dbFileName, sn, uuid);
  }

  @override
  Future<Map<String, dynamic>> downloadMedia(
    int fileSn,
    String fileName,
    void Function(double) onProgress,
  ) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {
        'success': false,
        'message': 'SQLite DB가 선택되지 않았습니다.',
      };
    }
    return _service.downloadMedia(dbFileName, fileSn, fileName, onProgress);
  }
}
