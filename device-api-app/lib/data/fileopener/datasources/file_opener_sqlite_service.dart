import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/fileopener_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef FileOpenerSqliteSetupStatus = SqliteSetupStatus;

class FileOpenerSqliteService {
  final FeatureTableService _featureTable;

  FileOpenerSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => FileOpenerSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<FileOpenerSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<FileOpenerSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  Future<List<ServerFileInfo>> getServerFileList(String fileName) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    final result = <ServerFileInfo>[];
    for (final row in rows) {
      final useYn = '${row['useYn'] ?? row['USEYN'] ?? 'Y'}';
      if (useYn.toUpperCase() == 'N') continue;
      result.add(_rowToServerFileInfo(row));
    }
    return result;
  }

  Future<FileOpenerInfo?> downloadServerFile(
    String fileName,
    ServerFileInfo serverFile,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return null;

    final row = await _findRowByFileSn(fileName, serverFile.fileSn);
    if (row == null) return null;

    final localPath = '${row['localPath'] ?? row['LOCALPATH'] ?? ''}';
    if (localPath.isEmpty) return null;

    final file = File(localPath);
    if (!await file.exists()) return null;

    final stat = await file.stat();
    final orignlFileNm =
        '${row['orignlFileNm'] ?? row['ORIGNLFILENM'] ?? serverFile.orignlFileNm}';
    final extension = orignlFileNm.contains('.')
        ? orignlFileNm.split('.').last.toLowerCase()
        : serverFile.fileExtension;

    return FileOpenerInfo(
      fileName: orignlFileNm,
      filePath: localPath,
      fileExtension: extension,
      mimeType: FileOpenerInfo.getMimeTypeFromExtension(extension),
      fileSize: stat.size,
      lastModified: stat.modified,
      isLocalFile: true,
      downloadUrl: null,
    );
  }

  Future<Map<String, Object?>?> _findRowByFileSn(
    String fileName,
    String fileSn,
  ) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    for (final row in rows) {
      final sn = '${row['fileSn'] ?? row['FILESN'] ?? ''}';
      if (sn == fileSn) return row;
    }
    return null;
  }

  ServerFileInfo _rowToServerFileInfo(Map<String, Object?> row) {
    return ServerFileInfo(
      fileSn: '${row['fileSn'] ?? row['FILESN'] ?? ''}',
      streFileNm: '${row['streFileNm'] ?? row['STREFILENM'] ?? ''}',
      orignlFileNm: '${row['orignlFileNm'] ?? row['ORIGNLFILENM'] ?? ''}',
      updDt: '${row['updDt'] ?? row['UPDDT'] ?? ''}',
      fileSize: '${row['fileSize'] ?? row['FILESIZE'] ?? '0'}',
    );
  }
}
