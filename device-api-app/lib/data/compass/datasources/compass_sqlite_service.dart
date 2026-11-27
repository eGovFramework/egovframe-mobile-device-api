import 'package:egovframe_mobile_deviceapi_app/config/compass_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef CompassSqliteSetupStatus = SqliteSetupStatus;

class CompassSqliteService {
  final FeatureTableService _featureTable;

  CompassSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => CompassSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<CompassSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<CompassSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadCompassInfo(String fileName, CompassInfo info) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;

    final sn = await _featureTable.nextMaxIntColumn(
      fileName,
      _schema,
      'sn',
      filterColumn: 'uuid',
      filterValue: info.uuid,
    );

    return _featureTable.insertRow(
      fileName,
      _schema,
      {
        'sn': sn,
        'uuid': info.uuid,
        'drc': info.drc,
        'accrcy': info.accrcy,
        'useYn': info.useYn,
        'timestamp': info.timestamp,
      },
    );
  }

  Future<List<CompassInfo>> getCompassList(String fileName) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToCompassInfo)
        .where((item) => item.useYn == 'Y')
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<bool> deleteCompassInfo(
    String fileName,
    CompassInfo info,
    String deviceUuid,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (info.sn <= 0 || deviceUuid.isEmpty || info.uuid != deviceUuid) {
      return false;
    }

    return _featureTable.deleteRow(
      fileName,
      _schema,
      {'sn': info.sn, 'uuid': deviceUuid},
    );
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  CompassInfo _rowToCompassInfo(Map<String, Object?> row) {
    return CompassInfo.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'],
      'drc': row['drc'],
      'accrcy': row['accrcy'],
      'useYn': row['useYn'],
      'timestamp': row['timestamp'],
    });
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
