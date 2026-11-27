import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/repositories/file_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/repositories/file_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/repositories/file_readwrite_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteRepositoryImpl _remote;
  final FileSqliteRepositoryImpl _sqlite;
  final FileReadWriteConnectionReader _readConnection;

  FileRepositoryImpl({
    required FileRemoteRepositoryImpl remote,
    required FileSqliteRepositoryImpl sqlite,
    required FileReadWriteConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  FileRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<List<FileInfo>> getAllLocalFiles([String? uuid]) =>
      _remote.getAllLocalFiles(uuid);

  @override
  Future<List<FileInfo>> importLocalFiles() => _remote.importLocalFiles();

  @override
  Future<bool> writeTextFile(String fileName, String content) =>
      _remote.writeTextFile(fileName, content);

  @override
  Future<String?> readTextFile(String fileName) =>
      _remote.readTextFile(fileName);

  @override
  Future<String?> readTextFileByPath(String filePath) =>
      _remote.readTextFileByPath(filePath);

  @override
  Future<List<FileInfo>> getFileInfoList(String uuid) =>
      _active.getFileInfoList(uuid);

  @override
  Future<Map<String, dynamic>> uploadFile({
    required String uuid,
    required List<File> files,
  }) =>
      _active.uploadFile(uuid: uuid, files: files);

  @override
  Future<File?> downloadFile({
    required String uuid,
    required int fileSn,
    required String fileName,
    required String savePath,
  }) =>
      _active.downloadFile(
        uuid: uuid,
        fileSn: fileSn,
        fileName: fileName,
        savePath: savePath,
      );

  @override
  Future<bool> deleteServerFile({required int sn}) =>
      _active.deleteServerFile(sn: sn);
}
