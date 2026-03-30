import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/file_readwrite_repository.dart';

class FileReadwriteUseCase {
  final FileRepository repository;

  FileReadwriteUseCase(this.repository);

  /// 파일 정보 목록 조회
  Future<List<FileInfo>> getFileInfoList(String uuid) async {
    return await repository.getFileInfoList(uuid);
  }

  /// 파일 업로드
  Future<Map<String, dynamic>> uploadFile({required String uuid, required List<File> files}) async {
    return await repository.uploadFile(uuid: uuid, files: files);
  }
}
