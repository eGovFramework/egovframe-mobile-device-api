import 'package:egovframe_mobile_deviceapi_app/config/device_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef DeviceSqliteSetupStatus = SqliteSetupStatus;

class DeviceSqliteService {
  final FeatureTableService _featureTable;

  DeviceSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => DeviceSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<DeviceSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<DeviceSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadDeviceInfo(String fileName, DeviceInfo info) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (info.uuid.isEmpty) return false;

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

  Future<List<DeviceInfo>> getDeviceList(
    String fileName,
    String uuid,
  ) async {
    if (uuid.isEmpty) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToDeviceInfo)
        .where((item) => item.useYn == 'Y' && item.uuid == uuid)
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<DeviceInfo?> getDeviceDetail(
    String fileName,
    int sn,
    String deviceUuid,
  ) async {
    if (sn <= 0 || !isDeviceUuidValid(deviceUuid)) return null;

    final rows = await _featureTable.queryRows(fileName, _schema);
    for (final row in rows) {
      final info = _rowToDeviceInfo(row);
      if (info.sn == sn && deviceBelongsToDevice(info, deviceUuid)) {
        return info;
      }
    }
    return null;
  }

  Future<bool> deleteDevice(String fileName, int sn, String deviceUuid) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (sn <= 0 || !isDeviceUuidValid(deviceUuid)) return false;

    return _featureTable.deleteRow(
      fileName,
      _schema,
      {'sn': sn, 'uuid': deviceUuid},
    );
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  DeviceInfo _rowToDeviceInfo(Map<String, Object?> row) {
    return DeviceInfo.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'] ?? row['UUID'],
      'os': row['os'] ?? row['OS'],
      'ntwrkDeviceInfo':
          row['ntwrkDeviceInfo'] ??
          row['ntwrk_device_info'] ??
          row['NTWRK_DEVICE_INFO'],
      'pgVer': row['pgVer'] ?? row['pg_ver'] ?? row['PG_VER'],
      'deviceNm': row['deviceNm'] ?? row['device_nm'] ?? row['DEVICE_NM'],
      'useYn': row['useYn'] ?? row['useyn'] ?? row['USEYN'],
      'telno': row['telno'] ?? row['TELNO'],
      'strgeInfo': row['strgeInfo'] ?? row['strge_info'] ?? row['STRGE_INFO'],
    });
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
