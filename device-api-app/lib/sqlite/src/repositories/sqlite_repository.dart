import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/column_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/database_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/index_definition.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_info.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/src/domain/entities/table_schema.dart';

abstract class SqliteRepository {
  Future<List<DatabaseInfo>> listDatabases();

  Future<void> createDatabase(String name, {int version = 1});

  Future<void> deleteDatabase(String fileName);

  Future<String> exportDatabase(String fileName);

  Future<String> prepareDatabaseShare(String fileName);

  Future<void> importDatabase(String sourcePath, String targetName);

  Future<List<TableInfo>> listTables(String fileName);

  Future<void> createTable(
    String fileName,
    String tableName,
    List<ColumnDefinition> columns, {
    List<IndexDefinition> indexes = const [],
  });

  Future<void> addColumn(
    String fileName,
    String tableName,
    ColumnDefinition column,
  );

  Future<TableSchema> getTableSchema(String fileName, String tableName);

  Future<List<Map<String, Object?>>> queryTable(
    String fileName,
    String tableName,
  );

  Future<int> insertRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
  );

  Future<int> updateRow(
    String fileName,
    String tableName,
    Map<String, Object?> values,
    Map<String, Object?> where,
  );

  Future<int> deleteRow(
    String fileName,
    String tableName,
    Map<String, Object?> where,
  );

  Future<List<String>> getTableColumns(String fileName, String tableName);
}
