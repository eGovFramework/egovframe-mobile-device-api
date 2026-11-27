import 'package:egovframe_mobile_deviceapi_app/config/accelerator_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef AcceleratorSqliteSetupStatus = SqliteSetupStatus;

class AcceleratorSqliteService {
  final FeatureTableService _featureTable;

  AcceleratorSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => AcceleratorSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<AcceleratorSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<AcceleratorSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadAcceleratorInfo(String fileName, AcceleratorInfo info) async {
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
        ...info.toSqliteRow(),
        'sn': sn,
      },
    );
  }

  Future<List<AcceleratorInfo>> getAcceleratorList(
    String fileName,
    String deviceUuid,
  ) async {
    if (!isDeviceUuidValid(deviceUuid)) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToAcceleratorInfo)
        .where(
          (item) =>
              item.useYn == 'Y' &&
              acceleratorBelongsToDevice(item, deviceUuid),
        )
        .toList();
  }

  Future<bool> deleteAcceleratorInfo(
    String fileName,
    AcceleratorInfo info,
    String deviceUuid,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (info.sn <= 0 || !acceleratorBelongsToDevice(info, deviceUuid)) {
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

  AcceleratorInfo _rowToAcceleratorInfo(Map<String, Object?> row) {
    return AcceleratorInfo.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'],
      'xaxis': row['xaxis']?.toString() ?? '0',
      'yaxis': row['yaxis']?.toString() ?? '0',
      'zaxis': row['zaxis']?.toString() ?? '0',
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
