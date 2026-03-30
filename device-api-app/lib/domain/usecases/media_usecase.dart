import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/media_repository.dart';
import 'package:image_picker/image_picker.dart';

class MediaUseCase {
  final MediaRepository repository;

  MediaUseCase(this.repository);


  /// 로컬 미디어 파일 목록 조회
  Future<List<MediaFileInfo>> getLocalMediaFiles() async {
    return await repository.getSavedMediaFiles();
  }

  /// 서버 미디어 목록 조회
  Future<List<MediaFileInfo>> getServerMediaList(String uuid) async {
    return await repository.getServerMediaList(uuid);
  }

  /// 파일 업로드 (단일 또는 여러 파일 지원)
  Future<Map<String, dynamic>> uploadFile({
    required List<File> files,
    required String uuid,
    required int startSn,
  }) async {
    return await repository.uploadMediaToServer(
      files: files,
      uuid: uuid,
      startSn: startSn,
    );
  }

  /// 이미지 선택 및 업로드
  Future<Map<String, dynamic>> pickAndUploadImage({
    required String uuid,
    required int sn,
    required ImageSource source,
  }) async {
    return await repository.pickAndUploadImage(
      uuid: uuid,
      sn: sn,
      source: source,
    );
  }

  /// 비디오 선택 및 업로드
  Future<Map<String, dynamic>> pickAndUploadVideo({
    required String uuid,
    required int sn,
    required ImageSource source,
  }) async {
    return await repository.pickAndUploadVideo(
      uuid: uuid,
      sn: sn,
      source: source,
    );
  }
}
