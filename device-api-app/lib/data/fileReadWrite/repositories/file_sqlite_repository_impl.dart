import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/datasources/file_readwrite_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/repositories/file_readwrite_repository.dart';

typedef FileReadWriteConnectionReader = FileReadWriteConnectionState Function();

class FileSqliteRepositoryImpl implements FileRepository {
  final FileReadWriteSqliteService _service;
  final FileReadWriteConnectionReader _readConnection;

  FileSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<List<FileInfo>> getFileInfoList(String uuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getFileInfoList(dbFileName, uuid);
  }

  @override
  Future<Map<String, dynamic>> uploadFile({
    required String uuid,
    required List<File> files,
  }) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {
        'success': false,
        'message': 'SQLite DB가 선택되지 않았습니다.',
        'resultState': 'FAIL',
      };
    }
    return _service.uploadFile(
      fileName: dbFileName,
      uuid: uuid,
      files: files,
    );
  }

  @override
  Future<File?> downloadFile({
    required String uuid,
    required int fileSn,
    required String fileName,
    required String savePath,
  }) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return null;
    return _service.downloadFile(
      fileName: dbFileName,
      uuid: uuid,
      fileSn: fileSn,
      downloadName: fileName,
      savePath: savePath,
    );
  }

  @override
  Future<bool> deleteServerFile({required int sn}) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteServerFile(dbFileName, sn);
  }

  @override
  Future<List<FileInfo>> getAllLocalFiles([String? uuid]) {
    throw UnsupportedError('SQLite 모드에서는 로컬 파일 목록을 remote에 위임합니다.');
  }

  @override
  Future<List<FileInfo>> importLocalFiles() {
    throw UnsupportedError('SQLite 모드에서는 로컬 import를 remote에 위임합니다.');
  }

  @override
  Future<bool> writeTextFile(String fileName, String content) {
    throw UnsupportedError('SQLite 모드에서는 텍스트 쓰기를 remote에 위임합니다.');
  }

  @override
  Future<String?> readTextFile(String fileName) {
    throw UnsupportedError('SQLite 모드에서는 텍스트 읽기를 remote에 위임합니다.');
  }

  @override
  Future<String?> readTextFileByPath(String filePath) {
    throw UnsupportedError('SQLite 모드에서는 텍스트 읽기를 remote에 위임합니다.');
  }
}
