import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/file_readwrite_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef FileReadWriteSqliteSetupStatus = SqliteSetupStatus;

class FileReadWriteSqliteService {
  final FeatureTableService _featureTable;

  FileReadWriteSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => FileReadWriteSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<FileReadWriteSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<FileReadWriteSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<List<FileInfo>> getFileInfoList(String fileName, String uuid) async {
    if (uuid.isEmpty) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToFileInfo)
        .where((item) => item.useYn == 'Y' && item.uuid == uuid)
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<Map<String, dynamic>> uploadFile({
    required String fileName,
    required String uuid,
    required List<File> files,
  }) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) {
      return {
        'success': false,
        'message': 'SQLite DB가 준비되지 않았습니다.',
        'resultState': 'FAIL',
      };
    }
    if (uuid.isEmpty || files.isEmpty) {
      return {
        'success': false,
        'message': '업로드할 파일이 없거나 UUID가 없습니다.',
        'resultState': 'FAIL',
      };
    }

    var successCount = 0;
    var failCount = 0;
    final fileResults = <Map<String, dynamic>>[];
    Map<String, dynamic>? lastFileVo;

    for (final file in files) {
      try {
        final sn = await _featureTable.nextMaxIntColumn(
          fileName,
          _schema,
          'sn',
          filterColumn: 'uuid',
          filterValue: uuid,
        );
        final baseName = _basename(file.path);
        final ext = _extension(baseName);
        final size = await file.length();
        final parentDir = _dirname(file.path);
        final now = DateTime.now().toIso8601String();

        final ok = await _featureTable.insertRow(
          fileName,
          _schema,
          {
            'sn': sn,
            'uuid': uuid,
            'useYn': 'Y',
            'fileSn': sn,
            'fileNm': baseName,
            'fileStreCours': parentDir,
            'streFileNm': baseName,
            'orignlFileNm': baseName,
            'fileExtsn': ext,
            'fileCn': '',
            'fileSize': size.toString(),
            'updtDt': now,
          },
        );

        if (ok) {
          successCount++;
          lastFileVo = {
            'fileSn': sn.toString(),
            'fileStreCours': parentDir,
            'fileExtsn': ext,
            'fileSize': size.toString(),
            'orignlFileNm': baseName,
            'streFileNm': baseName,
          };
          fileResults.add({
            'success': true,
            'fileSn': sn,
            'sn': sn,
            'orignlFileNm': baseName,
            'fileSize': size,
          });
        } else {
          failCount++;
          fileResults.add({
            'success': false,
            'orignlFileNm': baseName,
            'message': '메타데이터 저장 실패',
          });
        }
      } catch (e) {
        failCount++;
        fileResults.add({
          'success': false,
          'message': '$e',
        });
      }
    }

    final resultState = failCount == 0 && successCount > 0 ? 'OK' : 'FAIL';

    if (files.length == 1 && lastFileVo != null) {
      return {
        'success': resultState == 'OK',
        'resultState': resultState,
        'resultMessage': resultState == 'OK' ? '등록 성공' : '등록 실패',
        'message': resultState == 'OK' ? '등록 성공' : '등록 실패',
        'data': {
          'upload': {'fileVO': lastFileVo, 'resultState': resultState},
          'insert': {'resultState': resultState},
        },
      };
    }

    return {
      'success': resultState == 'OK',
      'resultState': resultState,
      'totalFiles': files.length,
      'successCount': successCount,
      'failCount': failCount,
      'fileResults': fileResults,
      'resultMessage': resultState == 'OK' ? '업로드 완료' : '업로드 실패',
      'data': {'fileResults': fileResults},
    };
  }

  Future<bool> deleteServerFile(String fileName, int sn) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready || sn <= 0) return false;

    return _featureTable.deleteRow(
      fileName,
      _schema,
      {'sn': sn},
    );
  }

  Future<File?> downloadFile({
    required String fileName,
    required String uuid,
    required int fileSn,
    required String downloadName,
    required String savePath,
  }) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    for (final row in rows) {
      final info = _rowToFileInfo(row);
      if (info.fileSn != fileSn && info.sn != fileSn) continue;
      if (uuid.isNotEmpty && info.uuid != uuid) continue;

      final sourcePath = _resolvePathFromRow(row) ?? info.filePath;
      if (sourcePath.isEmpty) return null;

      final source = File(sourcePath);
      if (!await source.exists()) {
        if (await File(savePath).exists()) return File(savePath);
        return null;
      }

      final target = File(savePath);
      await target.parent.create(recursive: true);
      await source.copy(savePath);
      return target;
    }
    return null;
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  FileInfo _rowToFileInfo(Map<String, Object?> row) {
    final server = FileReadWriteInfoServer.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'] ?? row['UUID'],
      'fileSn': row['fileSn'] ?? row['file_sn'] ?? row['FILE_SN'],
      'fileNm':
          row['fileNm'] ??
          row['fileName'] ??
          row['file_nm'] ??
          row['FILE_NM'],
      'orignlFileNm':
          row['orignlFileNm'] ??
          row['orignl_file_nm'] ??
          row['ORIGNL_FILE_NM'],
      'useYn': row['useYn'] ?? row['useyn'] ?? row['USEYN'],
      'fileStreCours':
          row['fileStreCours'] ??
          row['file_stre_cours'] ??
          row['FILE_STRE_COURS'],
      'streFileNm':
          row['streFileNm'] ?? row['stre_file_nm'] ?? row['STRE_FILE_NM'],
      'fileExtsn':
          row['fileExtsn'] ?? row['file_extsn'] ?? row['FILE_EXTSN'],
      'fileCn': row['fileCn'] ?? row['file_cn'] ?? row['FILE_CN'],
      'fileSize': row['fileSize'] ?? row['file_size'] ?? row['FILE_SIZE'],
      'updtDt': row['updtDt'] ?? row['updt_dt'] ?? row['UPDT_DT'],
    });

    return FileInfo(
      sn: server.sn,
      fileSn: server.fileSn,
      uuid: server.uuid,
      fileName: server.fileNm,
      filePath: server.fileStreCours.isNotEmpty
          ? _join(
              server.fileStreCours,
              server.streFileNm.isNotEmpty
                  ? server.streFileNm
                  : server.orignlFileNm,
            )
          : server.streFileNm,
      fileSize: server.fileSizeInt,
      uploadDate: server.updtDt,
      useYn: server.useYn,
    );
  }

  String? _resolvePathFromRow(Map<String, Object?> row) {
    final cours = (row['fileStreCours'] ??
            row['file_stre_cours'] ??
            row['FILE_STRE_COURS'] ??
            '')
        .toString();
    final stre = (row['streFileNm'] ??
            row['stre_file_nm'] ??
            row['STRE_FILE_NM'] ??
            '')
        .toString();
    final origin = (row['orignlFileNm'] ??
            row['orignl_file_nm'] ??
            row['ORIGNL_FILE_NM'] ??
            '')
        .toString();
    final fileNm = (row['fileNm'] ??
            row['fileName'] ??
            row['file_nm'] ??
            '')
        .toString();

    if (cours.isNotEmpty && stre.isNotEmpty) return _join(cours, stre);
    if (cours.isNotEmpty && origin.isNotEmpty) return _join(cours, origin);
    if (cours.isNotEmpty && fileNm.isNotEmpty) return _join(cours, fileNm);
    if (_isAbsolute(stre) && stre.isNotEmpty) return stre;
    if (_isAbsolute(origin) && origin.isNotEmpty) return origin;
    return null;
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }

  String _basename(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index < 0 ? normalized : normalized.substring(index + 1);
  }

  String _dirname(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    if (index <= 0) return '';
    return normalized.substring(0, index);
  }

  String _extension(String name) {
    final index = name.lastIndexOf('.');
    if (index < 0 || index == name.length - 1) return '';
    return name.substring(index + 1).toLowerCase();
  }

  String _join(String dir, String name) {
    if (dir.isEmpty) return name;
    final sep = dir.contains('\\') ? '\\' : '/';
    if (dir.endsWith('/') || dir.endsWith('\\')) return '$dir$name';
    return '$dir$sep$name';
  }

  bool _isAbsolute(String path) {
    if (path.startsWith('/')) return true;
    return path.length > 2 && path[1] == ':';
  }
}
