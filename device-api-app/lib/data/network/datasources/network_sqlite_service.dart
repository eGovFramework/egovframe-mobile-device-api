import 'package:egovframe_mobile_deviceapi_app/config/network_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef NetworkSqliteSetupStatus = SqliteSetupStatus;

class NetworkSqliteService {
  final FeatureTableService _featureTable;

  NetworkSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => NetworkSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<NetworkSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<NetworkSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadNetworkInfo(String fileName, NetworkInfo info) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;

    final sn = await _featureTable.nextMaxIntColumn(
      fileName,
      _schema,
      'sn',
      filterColumn: 'uuid',
      filterValue: info.deviceId,
    );

    return _featureTable.insertRow(
      fileName,
      _schema,
      {
        'sn': sn,
        'uuid': info.deviceId,
        'networktype': info.networkType,
        'useYn': info.useYn,
        'timestamp': info.registDate.toIso8601String(),
      },
    );
  }

  Future<List<NetworkInfo>> getNetworkList(
    String fileName, {
    required String uuid,
    String networkType = 'ALL',
  }) async {
    if (!isDeviceUuidValid(uuid)) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToNetworkInfo)
        .where((item) => item.useYn == 'Y')
        .where((item) => networkBelongsToDevice(item, uuid))
        .where(
          (item) =>
              networkType == 'ALL' || item.networkType == networkType,
        )
        .toList()
      ..sort((a, b) => b.registDate.compareTo(a.registDate));
  }

  Future<bool> deleteNetworkInfo(
    String fileName, {
    required String sn,
    required String uuid,
  }) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (!isDeviceUuidValid(uuid)) return false;

    final snValue = int.tryParse(sn);
    if (snValue == null) return false;

    return _featureTable.deleteRow(
      fileName,
      _schema,
      {'sn': snValue, 'uuid': uuid},
    );
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  NetworkInfo _rowToNetworkInfo(Map<String, Object?> row) {
    final networkType =
        (row['networktype'] ?? row['networkType'] ?? '').toString();
    final timestampRaw = row['timestamp']?.toString();
    DateTime registDate = DateTime.now();
    if (timestampRaw != null && timestampRaw.isNotEmpty) {
      try {
        registDate = DateTime.parse(timestampRaw);
      } catch (_) {}
    }

    return NetworkInfo(
      sn: row['sn']?.toString(),
      networkType: networkType,
      networkTypeName: NetworkInfo.getNetworkTypeName(networkType),
      deviceId: row['uuid']?.toString() ?? '',
      deviceName: '',
      useYn: (row['useYn'] ?? 'Y').toString(),
      registDate: registDate,
    );
  }
}
