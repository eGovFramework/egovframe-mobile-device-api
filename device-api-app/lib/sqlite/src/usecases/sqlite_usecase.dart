import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/column_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/database_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/index_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/repositories/sqlite_repository.dart';

class SqliteUseCase {
  final SqliteRepository _repository;

  SqliteUseCase(this._repository);

  Future<List<DatabaseInfo>> loadDatabases() => _repository.listDatabases();

  Future<void> createDatabase(String name, {int version = 1}) =>
      _repository.createDatabase(name, version: version);

  Future<void> deleteDatabase(String fileName) =>
      _repository.deleteDatabase(fileName);

  Future<String> exportDatabase(String fileName) =>
      _repository.exportDatabase(fileName);

  Future<String> prepareDatabaseShare(String fileName) =>
      _repository.prepareDatabaseShare(fileName);

  Future<void> importDatabase(String sourcePath, String targetName) =>
      _repository.importDatabase(sourcePath, targetName);

  Future<List<TableInfo>> loadTables(String fileName) =>
      _repository.listTables(fileName);

  Future<void> createTable(
    String fileName,
    String tableName,
    List<ColumnDefinition> columns, {
    List<IndexDefinition> indexes = const [],
  }) =>
      _repository.createTable(
        fileName,
        tableName,
        columns,
        indexes: indexes,
      );

  Future<void> addColumn(
    String fileName,
    String tableName,
    ColumnDefinition column,
  ) =>
      _repository.addColumn(fileName, tableName, column);

  Future<TableSchema> loadTableSchema(String fileName, String tableName) =>
      _repository.getTableSchema(fileName, tableName);

  Future<List<Map<String, Object?>>> loadTableData(
    String fileName,
    String tableName,
  ) =>
      _repository.queryTable(fileName, tableName);

  Future<int> insertRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
  ) =>
      _repository.insertRow(fileName, tableName, values);

  Future<int> updateRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
    Map<String, Object?> where,
  ) =>
      _repository.updateRow(fileName, tableName, values, where);

  Future<int> deleteRow(
    String fileName,
    String tableName,
    Map<String, Object?> where,
  ) =>
      _repository.deleteRow(fileName, tableName, where);

  Future<List<String>> loadTableColumns(String fileName, String tableName) =>
      _repository.getTableColumns(fileName, tableName);

  Map<String, Object?> buildRowWhere(
    Map<String, Object?> row,
    List<String> primaryKeyColumns,
  ) {
    if (primaryKeyColumns.isNotEmpty) {
      return {
        for (final key in primaryKeyColumns) key: row[key],
      };
    }
    return {'rowid': row['__rowid__']};
  }
}
