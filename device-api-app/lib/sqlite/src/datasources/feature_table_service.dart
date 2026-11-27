import 'package:egovframe_mobile_deviceapi_app/sqlite/src/config/sqlite_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/datasources/sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/schema/sqlite_feature_schema.dart';

/// 기능 앱별 SQLite 테이블 검증·CRUD 헬퍼.
class FeatureTableService {
  final SqliteService _sqliteService;

  FeatureTableService(this._sqliteService);

  Future<List<String>> findDatabasesWithTable(SqliteFeatureSchema schema) async {
    final databases = await _sqliteService.listDatabases();
    final matched = <String>[];

    for (final database in databases) {
      if (await hasFeatureTable(database.fileName, schema)) {
        matched.add(database.fileName);
      }
    }

    return matched;
  }

  Future<bool> databaseExists(String fileName) async {
    final databases = await _sqliteService.listDatabases();
    return databases.any((database) => database.fileName == fileName);
  }

  Future<bool> hasFeatureTable(
    String fileName,
    SqliteFeatureSchema schema,
  ) async {
    if (!await databaseExists(fileName)) return false;

    final actualTableName = await _resolveTableName(fileName, schema.tableName);
    if (actualTableName == null) {
      return false;
    }

    final columns = await _sqliteService.getTableColumns(
      fileName,
      actualTableName,
    );
    final columnSet = columns.map((name) => name.toLowerCase()).toSet();
    return schema.requiredColumns.every(
      (column) => columnSet.contains(column.toLowerCase()),
    );
  }

  Future<SqliteSetupStatus> validateSetup(
    String fileName,
    SqliteFeatureSchema schema,
  ) async {
    if (!await databaseExists(fileName)) {
      return SqliteSetupStatus.noDatabase;
    }
    if (!await hasFeatureTable(fileName, schema)) {
      return SqliteSetupStatus.noFeatureTable;
    }
    return SqliteSetupStatus.ready;
  }

  Future<SqliteSetupStatus> validateAnyDatabase(
    SqliteFeatureSchema schema,
  ) async {
    final databases = await _sqliteService.listDatabases();
    if (databases.isEmpty) {
      return SqliteSetupStatus.noDatabase;
    }

    for (final database in databases) {
      if (await hasFeatureTable(database.fileName, schema)) {
        return SqliteSetupStatus.ready;
      }
    }

    return SqliteSetupStatus.noFeatureTable;
  }

  Future<bool> insertRow(
    String fileName,
    SqliteFeatureSchema schema,
    Map<String, Object?> values,
  ) async {
    final status = await validateSetup(fileName, schema);
    if (status != SqliteSetupStatus.ready) return false;

    try {
      final tableName = await _requireTableName(fileName, schema.tableName);
      await _sqliteService.insertRow(fileName, tableName, values);
      return true;
    } catch (e) {
      SqliteConfig.log('FeatureTableService.insertRow failed: $e');
      return false;
    }
  }

  Future<List<Map<String, Object?>>> queryRows(
    String fileName,
    SqliteFeatureSchema schema, {
    String? filterColumn,
    String? filterValue,
  }) async {
    final status = await validateSetup(fileName, schema);
    if (status != SqliteSetupStatus.ready) return [];

    final tableName = await _requireTableName(fileName, schema.tableName);
    final rows = await _sqliteService.queryTable(fileName, tableName);
    if (filterColumn == null || filterValue == null) {
      return rows;
    }

    return rows
        .where((row) => '${row[filterColumn] ?? ''}' == filterValue)
        .toList();
  }

  Future<bool> deleteRow(
    String fileName,
    SqliteFeatureSchema schema,
    Map<String, Object?> where,
  ) async {
    final status = await validateSetup(fileName, schema);
    if (status != SqliteSetupStatus.ready) return false;

    final tableName = await _requireTableName(fileName, schema.tableName);
    final deleted = await _sqliteService.deleteRow(
      fileName,
      tableName,
      where,
    );
    return deleted > 0;
  }

  Future<bool> updateRow(
    String fileName,
    SqliteFeatureSchema schema,
    Map<String, Object?> values,
    Map<String, Object?> where,
  ) async {
    final status = await validateSetup(fileName, schema);
    if (status != SqliteSetupStatus.ready) return false;

    try {
      final tableName = await _requireTableName(fileName, schema.tableName);
      final updated = await _sqliteService.updateRow(
        fileName,
        tableName,
        values,
        where,
      );
      return updated > 0;
    } catch (e) {
      SqliteConfig.log('FeatureTableService.updateRow failed: $e');
      return false;
    }
  }

  /// [columnName]의 다음 값(max+1)을 반환한다.
  ///
  /// [filterColumn]/[filterValue]가 있으면 해당 조건 행만 대상으로 채번한다.
  /// (예: UUID별 SN = `filterColumn: 'uuid', filterValue: deviceUuid`)
  Future<int> nextMaxIntColumn(
    String fileName,
    SqliteFeatureSchema schema,
    String columnName, {
    String? filterColumn,
    String? filterValue,
  }) async {
    final tableName = await _requireTableName(fileName, schema.tableName);
    final rows = await _sqliteService.queryTable(fileName, tableName);
    var maxValue = 0;
    for (final row in rows) {
      if (filterColumn != null && filterValue != null) {
        final rowFilter = '${row[filterColumn] ?? ''}';
        if (rowFilter != filterValue) continue;
      }
      final raw = row[columnName] ?? row['__rowid__'];
      final value = raw is int ? raw : int.tryParse('$raw') ?? 0;
      if (value > maxValue) maxValue = value;
    }
    return maxValue + 1;
  }

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _sqliteService.importDatabase(sourcePath, targetName);

  Future<String?> _resolveTableName(String fileName, String tableName) async {
    final tables = await _sqliteService.listTables(fileName);
    for (final table in tables) {
      if (table.name.toLowerCase() == tableName.toLowerCase()) {
        return table.name;
      }
    }
    return null;
  }

  Future<String> _requireTableName(String fileName, String tableName) async {
    final actual = await _resolveTableName(fileName, tableName);
    if (actual == null) {
      throw StateError('table_not_found: $tableName');
    }
    return actual;
  }
}
