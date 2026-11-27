import 'package:egovframe_mobile_deviceapi_app/config/streaming_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef StreamingSqliteSetupStatus = SqliteSetupStatus;

class StreamingSqliteService {
  final FeatureTableService _featureTable;
  final SqliteService _sqliteService;

  StreamingSqliteService(this._featureTable, this._sqliteService);

  SqliteFeatureSchema get _schema => StreamingSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<StreamingSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<StreamingSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<List<StreamingMediaInfo>> getMediaList(String fileName) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToStreamingMediaInfo)
        .where((item) => item.mdSj.isNotEmpty)
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<bool> updatePlayCount(String fileName, int sn) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;

    final rows = await _featureTable.queryRows(fileName, _schema);
    for (final row in rows) {
      if (_readSn(row) != sn) continue;

      final current = int.tryParse('${row['revivCo'] ?? row['REVIV_CO'] ?? 0}') ?? 0;
      final updated = await _sqliteService.updateRow(
        fileName,
        _schema.tableName,
        {'revivCo': '${current + 1}'},
        {'sn': sn},
      );
      return updated > 0;
    }
    return false;
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  StreamingMediaInfo _rowToStreamingMediaInfo(Map<String, Object?> row) {
    return StreamingMediaInfo.fromJson({
      'sn': _readSn(row),
      'fileSn': row['fileSn'] ?? row['FILE_SN'] ?? row['file_sn'],
      'mdSj': row['mdSj'] ?? row['MD_SJ'] ?? row['md_sj'],
      'mdCode': row['mdCode'] ?? row['MD_CODE'] ?? row['md_code'],
      'revivCo': row['revivCo'] ?? row['REVIV_CO'] ?? row['reviv_co'],
    });
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
