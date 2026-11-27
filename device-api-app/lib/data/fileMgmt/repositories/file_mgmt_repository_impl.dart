import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/fileMgmt/datasources/file_management_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/repositories/file_mgmt_repository.dart';

class FileMgmtRepositoryImpl implements FileMgmtRepository {
  final FileManagementService _service;

  FileMgmtRepositoryImpl(this._service);

  @override
  Future<bool> requestPermissions() => _service.requestPermissions();

  @override
  Future<bool> openPermissionSettings() => _service.openPermissionSettings();

  @override
  Future<String> getDocumentsRoot() => _service.getApplicationDocumentsPath();

  @override
  Future<List<FileSystemEntity>> listDirectory(String path) =>
      _service.listDirectoryContents(path);

  @override
  Future<Map<String, dynamic>> getFileInfo(String path) =>
      _service.getFileInfo(path);

  @override
  Future<void> createDirectory(String parentPath, String name) =>
      _service.createDirectory(parentPath, name);

  @override
  Future<void> createSampleFile(
    String parentPath,
    String fileName,
    String content,
  ) async {
    await _service.createSampleFile(parentPath, fileName, content);
  }

  @override
  Future<void> deletePath(String path) async {
    await _service.deleteFileOrDirectory(path);
  }

  @override
  Future<void> copyPath(String sourcePath, String destinationDir) async {
    await _service.copyFileOrDirectory(sourcePath, destinationDir);
  }

  @override
  Future<void> copyPathWithNewName({
    required String sourcePath,
    required String destinationDir,
    required String copySuffix,
  }) =>
      _service.copyWithGeneratedName(
        sourcePath: sourcePath,
        destinationDir: destinationDir,
        copySuffix: copySuffix,
      );

  @override
  Future<void> movePath(String sourcePath, String destinationDir) async {
    await _service.moveFileOrDirectory(sourcePath, destinationDir);
  }

  @override
  Future<void> renamePath(String sourcePath, String newPath) =>
      _service.renamePath(sourcePath, newPath);

  @override
  Future<bool> exists(String path) => _service.exists(path);
}
