import 'package:egovframe_mobile_deviceapi_app/sqlite/src/datasources/sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/column_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/database_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/index_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_schema.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/repositories/sqlite_repository.dart';

class SqliteRepositoryImpl implements SqliteRepository {
  final SqliteService _service;

  SqliteRepositoryImpl(this._service);

  @override
  Future<List<DatabaseInfo>> listDatabases() => _service.listDatabases();

  @override
  Future<void> createDatabase(String name, {int version = 1}) =>
      _service.createDatabase(name, version: version);

  @override
  Future<void> deleteDatabase(String fileName) =>
      _service.deleteDatabase(fileName);

  @override
  Future<String> exportDatabase(String fileName) =>
      _service.exportDatabase(fileName);

  @override
  Future<String> prepareDatabaseShare(String fileName) =>
      _service.prepareDatabaseShare(fileName);

  @override
  Future<void> importDatabase(String sourcePath, String targetName) =>
      _service.importDatabase(sourcePath, targetName);

  @override
  Future<List<TableInfo>> listTables(String fileName) =>
      _service.listTables(fileName);

  @override
  Future<void> createTable(
    String fileName,
    String tableName,
    List<ColumnDefinition> columns, {
    List<IndexDefinition> indexes = const [],
  }) =>
      _service.createTable(
        fileName,
        tableName,
        columns,
        indexes: indexes,
      );

  @override
  Future<void> addColumn(
    String fileName,
    String tableName,
    ColumnDefinition column,
  ) =>
      _service.addColumn(fileName, tableName, column);

  @override
  Future<TableSchema> getTableSchema(String fileName, String tableName) =>
      _service.getTableSchema(fileName, tableName);

  @override
  Future<List<Map<String, Object?>>> queryTable(
    String fileName,
    String tableName,
  ) =>
      _service.queryTable(fileName, tableName);

  @override
  Future<int> insertRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
  ) =>
      _service.insertRow(fileName, tableName, values);

  @override
  Future<int> updateRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
    Map<String, Object?> where,
  ) =>
      _service.updateRow(fileName, tableName, values, where);

  @override
  Future<int> deleteRow(
    String fileName,
    String tableName,
    Map<String, Object?> where,
  ) =>
      _service.deleteRow(fileName, tableName, where);

  @override
  Future<List<String>> getTableColumns(String fileName, String tableName) =>
      _service.getTableColumns(fileName, tableName);
}
