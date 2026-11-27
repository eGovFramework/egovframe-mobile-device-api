import 'package:egovframe_mobile_deviceapi_app/config/socket_sqlite_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

typedef SocketSqliteSetupStatus = SqliteSetupStatus;

class SocketSqliteService {
  final FeatureTableService _featureTable;

  SocketSqliteService(this._featureTable);

  SqliteFeatureSchema get _schema => SocketSqliteSchema.schema;

  Future<List<String>> findDatabasesWithFeatureTable() =>
      _featureTable.findDatabasesWithTable(_schema);

  Future<bool> databaseExists(String fileName) =>
      _featureTable.databaseExists(fileName);

  Future<bool> hasFeatureTable(String fileName) =>
      _featureTable.hasFeatureTable(fileName, _schema);

  Future<SocketSqliteSetupStatus> validateSetup(String fileName) =>
      _featureTable.validateSetup(fileName, _schema);

  Future<SocketSqliteSetupStatus> validateAnyDatabase() =>
      _featureTable.validateAnyDatabase(_schema);

  Future<int?> uploadSocketMessageInfo(
    String fileName,
    SocketMessageInfo info,
  ) async {
    final status = await validateSetup(fileName);
    if (status != SqliteSetupStatus.ready) return null;

    final sn = await _nextSnForUuid(fileName, info.uuid);

    final inserted = await _featureTable.insertRow(
      fileName,
      _schema,
      {
        'sn': sn,
        'uuid': info.uuid,
        'message': info.message,
        'sender': info.sender,
        'useYn': info.useYn,
        'timestamp': info.timestamp,
      },
    );
    return inserted ? sn : null;
  }

  Future<int> _nextSnForUuid(String fileName, String uuid) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    var maxSn = 0;
    for (final row in rows) {
      if ('${row['uuid']}' != uuid) continue;
      final sn = int.tryParse('${row['sn']}') ?? 0;
      if (sn > maxSn) maxSn = sn;
    }
    return maxSn + 1;
  }

  Future<List<SocketMessageInfo>> getSocketMessageList(String fileName) async {
    final rows = await _featureTable.queryRows(fileName, _schema);
    return rows
        .map(_rowToSocketMessageInfo)
        .where((item) => item.useYn == 'Y')
        .toList()
      ..sort((a, b) => b.sn.compareTo(a.sn));
  }

  Future<bool> deleteAllSocketMessageInfo(String fileName) async {
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

  SocketMessageInfo _rowToSocketMessageInfo(Map<String, Object?> row) {
    return SocketMessageInfo.fromJson({
      'sn': _readSn(row),
      'uuid': row['uuid'],
      'message': row['message'],
      'sender': row['sender'],
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
