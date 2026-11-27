import 'package:egovframe_mobile_deviceapi_app/config/gps_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef GpsSqliteSetupStatus = SqliteSetupStatus;

class GpsSqliteService {
  final FeatureTableService _featureTable;

  GpsSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => GpsSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<GpsSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<GpsSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadGpsInfo(String fileName, GpsInfo info) async {
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
        'lat': info.latitude.toString(),
        'lon': info.longitude.toString(),
        'accrcy': info.accrcy?.toString() ?? '0',
        'useYn': 'Y',
        'timestamp': info.timestamp.toIso8601String(),
      },
    );
  }

  Future<List<GpsInfo>> getGpsList(String fileName) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToGpsInfo)
        .where((item) => item.uuid.isNotEmpty)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<bool> deleteGpsInfo(
    String fileName,
    GpsInfo info,
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

  GpsInfo _rowToGpsInfo(Map<String, Object?> row) {
    final timestampRaw = row['timestamp']?.toString() ?? '';
    DateTime timestamp;
    try {
      timestamp = DateTime.parse(timestampRaw);
    } catch (_) {
      final millis = int.tryParse(timestampRaw);
      timestamp = millis != null
          ? DateTime.fromMillisecondsSinceEpoch(millis)
          : DateTime.now();
    }

    return GpsInfo(
      sn: _readSn(row),
      uuid: row['uuid']?.toString() ?? '',
      latitude: double.tryParse(row['lat']?.toString() ?? '') ?? 0,
      longitude: double.tryParse(row['lon']?.toString() ?? '') ?? 0,
      accrcy: double.tryParse(row['accrcy']?.toString() ?? ''),
      timestamp: timestamp,
    );
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
