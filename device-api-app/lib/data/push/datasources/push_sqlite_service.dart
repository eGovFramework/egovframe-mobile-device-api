import 'package:egovframe_mobile_deviceapi_app/config/push_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef PushSqliteSetupStatus = SqliteSetupStatus;

class PushSqliteService {
  final FeatureTableService _featureTable;

  PushSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => PushSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<PushSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<PushSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> registerPushDevice(String fileName, PushDeviceInfo info) async {
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
        'ntwrkDeviceInfo': info.ntwrkDeviceInfo,
        'osVer': info.osVer,
        'deviceNm': info.deviceNm,
        'useYn': info.useYn,
        'osType': info.osType,
        'tokenId': info.tokenId,
      },
    );
  }

  Future<List<PushDeviceInfo>> getPushDeviceList(String fileName) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToPushDeviceInfo)
        .where((item) => item.useYn == 'Y')
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<bool> deleteAllPushDevices(String fileName) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;

    final rows = await _featureTable.queryRows(fileName, _schema);
    for (final row in rows) {
      final sn = _readSn(row);
      if (sn <= 0) continue;
      final deleted = await _featureTable.deleteRow(
        fileName,
        _schema,
        {'sn': sn},
      );
      if (!deleted) return false;
    }
    return true;
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  PushDeviceInfo _rowToPushDeviceInfo(Map<String, Object?> row) {
    return PushDeviceInfo.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'],
      'ntwrkDeviceInfo': row['ntwrkDeviceInfo'],
      'osVer': row['osVer'],
      'deviceNm': row['deviceNm'],
      'useYn': row['useYn'],
      'osType': row['osType'],
      'tokenId': row['tokenId'],
    });
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
