import 'package:egovframe_mobile_deviceapi_app/config/barcode_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_uuid_guard.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef BarcodeSqliteSetupStatus = SqliteSetupStatus;

class BarcodeSqliteService {
  final FeatureTableService _featureTable;

  BarcodeSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => BarcodeSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<BarcodeSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<BarcodeSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<bool> uploadBarcodeInfo(String fileName, BarcodeInfo info) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (!isDeviceUuidValid(info.uuid ?? '')) return false;

    final sn = await _featureTable.nextMaxIntColumn(
      fileName,
      _schema,
      'sn',
    );

    return _featureTable.insertRow(
      fileName,
      _schema,
      {
        'sn': sn,
        'uuid': info.uuid,
        'codeType': info.codeType,
        'codeText': info.codeText,
        'useYn': info.useYn,
        'codeDt': info.codeDt,
      },
    );
  }

  Future<List<BarcodeInfo>> getBarcodeList(
    String fileName,
    String deviceUuid,
  ) async {
    if (!isDeviceUuidValid(deviceUuid)) return [];

    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToBarcodeInfo)
        .where(
          (item) => item.useYn == 'Y' && barcodeBelongsToDevice(item, deviceUuid),
        )
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<bool> deleteBarcodeInfo(
    String fileName,
    BarcodeInfo info,
    String deviceUuid,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return false;
    if (info.sn <= 0 || info.codeType.isEmpty) return false;
    if (!barcodeBelongsToDevice(info, deviceUuid)) return false;

    return _featureTable.deleteRow(
      fileName,
      _schema,
      {'sn': info.sn, 'codeType': info.codeType, 'uuid': deviceUuid},
    );
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _featureTable.importDatabase(sourcePath, targetName);

  BarcodeInfo _rowToBarcodeInfo(Map<String, Object?> row) {
    return BarcodeInfo.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'],
      'codeType': row['codeType'] ?? row['code_type'] ?? row['CODE_TYPE'],
      'codeText': row['codeText'] ?? row['code_text'] ?? row['CODE_TEXT'],
      'useYn': row['useYn'] ?? row['useyn'] ?? row['USEYN'],
      'codeDt': row['codeDt'] ?? row['code_dt'] ?? row['CODE_DT'],
    });
  }

  int _readSn(Map<String, Object?> row) {
    final raw = row['sn'] ?? row['SN'] ?? row['__rowid__'];
    if (raw is int) return raw;
    return int.tryParse('$raw') ?? 0;
  }
}
