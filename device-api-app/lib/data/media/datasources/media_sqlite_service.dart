import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/media_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef MediaSqliteSetupStatus = SqliteSetupStatus;

class MediaSqliteService {
  final FeatureTableService _featureTable;

  MediaSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => MediaSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<MediaSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<MediaSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<List<MediaFileInfo>> getServerMediaList(
    String fileName,
    String uuid,
  ) async {
    if (uuid.isEmpty) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToMediaFileInfo)
        .where((item) {
          final useYn = (item.useyn ?? '').toUpperCase();
          return useYn == 'Y' && item.uuid == uuid;
        })
        .toList()
      ..sort((a, b) => (b.serverSn ?? 0).compareTo(a.serverSn ?? 0));
  }

  Future<Map<String, dynamic>> uploadMediaToServer({
    required String fileName,
    required List<File> files,
    required String uuid,
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
    int? lastSn;

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

        final ok = await _featureTable.insertRow(
          fileName,
          _schema,
          {
            'sn': sn,
            'uuid': uuid,
            'useYn': 'Y',
            'fileSn': sn,
            'mdCode': ext,
            'mdSj': baseName,
            'revivCo': '0',
            'fileStreCours': parentDir,
            'streFileNm': baseName,
            'orignlFileNm': baseName,
            'fileExtsn': ext,
            'fileCn': '',
          },
        );

        if (ok) {
          successCount++;
          lastSn = sn;
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

    final resultState = failCount == 0
        ? 'OK'
        : (successCount > 0 ? 'PARTIAL' : 'FAIL');

    if (files.length == 1) {
      return {
        'success': resultState == 'OK',
        'resultState': resultState,
        'resultMessage': resultState == 'OK' ? '업로드 성공' : '업로드 실패',
        'fileSn': lastSn,
        'totalFiles': 1,
        'successCount': successCount,
        'failCount': failCount,
        'data': {'fileResults': fileResults},
      };
    }

    return {
      'success': resultState == 'OK' || resultState == 'PARTIAL',
      'resultState': resultState,
      'totalFiles': files.length,
      'successCount': successCount,
      'failCount': failCount,
      'fileResults': fileResults,
      'resultMessage': resultState == 'OK'
          ? '모든 파일 업로드 성공'
          : resultState == 'PARTIAL'
              ? '일부 파일 업로드 성공'
              : '업로드 실패',
      'data': {'fileResults': fileResults},
    };
  }

  Future<Map<String, dynamic>> deleteMediaFromServer(
    String fileName,
    int sn,
    String uuid,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready || sn <= 0 || uuid.isEmpty) {
      return {
        'success': false,
        'message': '삭제할 수 없습니다.',
        'resultState': 'FAIL',
      };
    }

    final ok = await _featureTable.deleteRow(
      fileName,
      _schema,
      {'sn': sn, 'uuid': uuid},
    );

    return {
      'success': ok,
      'resultState': ok ? 'OK' : 'FAIL',
      'resultMessage': ok ? '삭제 성공' : '삭제 실패',
      'data': {'sn': sn},
    };
  }

  Future<String?> resolveLocalPath(String fileName, int sn) async {
    if (sn <= 0) return null;
    final rows = await _featureTable.queryRows(fileName, _schema);
    for (final row in rows) {
      if (_readSn(row) != sn) continue;
      return _resolvePathFromRow(row);
    }
    return null;
  }

  Future<Map<String, dynamic>> downloadMedia(
    String fileName,
    int fileSn,
    String downloadFileName,
    void Function(double) onProgress,
  ) async {
    onProgress(0.3);
    final localPath = await resolveLocalPath(fileName, fileSn);
    onProgress(0.8);

    if (localPath == null || !await File(localPath).exists()) {
      return {
        'success': false,
        'message': 'SQLite 메타데이터에서 로컬 파일을 찾을 수 없습니다.',
      };
    }

    onProgress(1.0);
    return {
      'success': true,
      'message': '다운로드 성공',
      'filePath': localPath,
    };
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  MediaFileInfo _rowToMediaFileInfo(Map<String, Object?> row) {
    return MediaFileInfo.fromServerApi({
      'sn': _readSn(row),
      'uuid': row['uuid'] ?? row['UUID'],
      'fileSn': row['fileSn'] ?? row['file_sn'] ?? row['FILE_SN'],
      'mdCode': row['mdCode'] ?? row['md_code'] ?? row['MD_CODE'],
      'mdSj': row['mdSj'] ?? row['md_sj'] ?? row['MD_SJ'],
      'useyn': row['useYn'] ?? row['useyn'] ?? row['USEYN'],
      'useYn': row['useYn'] ?? row['useyn'] ?? row['USEYN'],
      'revivCo': row['revivCo'] ?? row['reviv_co'] ?? row['REVIV_CO'],
      'fileStreCours':
          row['fileStreCours'] ??
          row['file_stre_cours'] ??
          row['FILE_STRE_COURS'],
      'streFileNm':
          row['streFileNm'] ?? row['stre_file_nm'] ?? row['STRE_FILE_NM'],
      'orignlFileNm':
          row['orignlFileNm'] ??
          row['orignl_file_nm'] ??
          row['ORIGNL_FILE_NM'],
      'fileExtsn':
          row['fileExtsn'] ?? row['file_extsn'] ?? row['FILE_EXTSN'],
      'fileCn': row['fileCn'] ?? row['file_cn'] ?? row['FILE_CN'],
    });
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

    if (cours.isNotEmpty && stre.isNotEmpty) {
      return _join(cours, stre);
    }
    if (cours.isNotEmpty && origin.isNotEmpty) {
      return _join(cours, origin);
    }
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
