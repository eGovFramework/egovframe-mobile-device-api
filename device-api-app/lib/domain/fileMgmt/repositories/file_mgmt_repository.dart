import 'dart:io';

abstract class FileMgmtRepository {
  Future<bool> requestPermissions();
  Future<bool> openPermissionSettings();
  Future<String> getDocumentsRoot();
  Future<List<FileSystemEntity>> listDirectory(String path);
  Future<Map<String, dynamic>> getFileInfo(String path);
  Future<void> createDirectory(String parentPath, String name);
  Future<void> createSampleFile(
    String parentPath,
    String fileName,
    String content,
  );
  Future<void> deletePath(String path);
  Future<void> copyPath(String sourcePath, String destinationDir);
  Future<void> copyPathWithNewName({
    required String sourcePath,
    required String destinationDir,
    required String copySuffix,
  });
  Future<void> movePath(String sourcePath, String destinationDir);
  Future<void> renamePath(String sourcePath, String newPath);
  Future<bool> exists(String path);
}
