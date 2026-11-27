import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/datasources/file_readwrite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/repositories/file_readwrite_repository.dart';

class FileRemoteRepositoryImpl implements FileRepository {
  FileRemoteRepositoryImpl();

  @override
  Future<List<FileInfo>> getFileInfoList(String uuid) async {
    final serverFiles = await FileReadWriteService.getFileInfoList(uuid);
    return serverFiles.map(_convertToFileInfo).toList();
  }

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
  Future<Map<String, dynamic>> uploadFile({
    required String uuid,
    required List<File> files,
  }) async {
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

  FileInfo _localFileToFileInfo(LocalFileInfo localFile, [String? uuid]) {
    return FileInfo(
      sn: 0,
      fileSn: 0,
      uuid: uuid ?? '',
      fileName: localFile.name,
      filePath: localFile.path,
      fileSize: localFile.size,
      uploadDate: localFile.lastModified.toIso8601String(),
      useYn: 'Y',
    );
  }

  @override
  Future<List<FileInfo>> getAllLocalFiles([String? uuid]) async {
    final localFiles = await FileReadWriteService.getWorkspaceFileList();
    return localFiles.map((f) => _localFileToFileInfo(f, uuid)).toList();
  }

  @override
  Future<List<FileInfo>> importLocalFiles() async {
    final imported = await FileReadWriteService.pickAndImportFiles();
    return imported.map(_localFileToFileInfo).toList();
  }

  @override
  Future<bool> writeTextFile(String fileName, String content) async {
    return await FileReadWriteService.writeTextFile(fileName, content);
  }

  @override
  Future<String?> readTextFile(String fileName) async {
    return await FileReadWriteService.readTextFile(fileName);
  }

  @override
  Future<String?> readTextFileByPath(String filePath) async {
    return await FileReadWriteService.readTextFileByPath(filePath);
  }
}
