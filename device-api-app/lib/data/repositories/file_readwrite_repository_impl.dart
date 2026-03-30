import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/datasources/file_readwrite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/file_readwrite_repository.dart';

class FileRepositoryImpl implements FileRepository {
  FileRepositoryImpl();

  @override
  Future<List<FileInfo>> getFileInfoList(String uuid) async {
    final serverFiles = await FileReadWriteService.getFileInfoList(uuid);
    return serverFiles.map((serverFile) => _convertToFileInfo(serverFile)).toList();
  }

  /// FileInfoServer를 FileInfo로 변환하는 헬퍼 메서드
  FileInfo _convertToFileInfo(FileReadWriteInfoServer serverFile) {
    return FileInfo(
      sn: serverFile.sn,
      fileSn: serverFile.fileSn,
      uuid: serverFile.uuid,
      fileName: serverFile.fileNm,
      filePath: serverFile.fileStreCours,
      fileSize: serverFile.fileSizeInt,
      uploadDate: serverFile.updtDt,
      useYn: serverFile.useYn,
    );
  }

  @override
  Future<Map<String,dynamic>> uploadFile({required String uuid, required List<File> files}) async {
    return await FileReadWriteService.uploadFile(uuid: uuid, files: files);
  }

  @override
  Future<File?> downloadFile({
    required String uuid,
    required int fileSn,
    required String fileName,
    required String savePath,
  }) async {
    return await FileReadWriteService.downloadFile(
      uuid: uuid,
      fileSn: fileSn,
      fileName: fileName,
      savePath: savePath,
    );
  }

  @override
  Future<bool> deleteServerFile({
    required int sn,
  }) async {
    return await FileReadWriteService.deleteServerFile(sn: sn);
  }
}
