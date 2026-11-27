import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:egovframe_mobile_deviceapi_app/di/sqlite_manager_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/state/sqlite_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sqlite_controller.g.dart';

SqliteUseCase _sqliteUseCase(Ref ref) => ref.read(sqliteManagerUseCaseProvider);

@Riverpod(keepAlive: true)
class SqliteMain extends _$SqliteMain {
  @override
  SqliteMainState build() {
    Future.microtask(loadDatabases);
    return SqliteMainState.initial();
  }

  Future<void> loadDatabases() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final databases = await _sqliteUseCase(ref).loadDatabases();
      state = state.copyWith(
        isLoading: false,
        databases: databases,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<String?> createDatabase(String name, {int version = 1}) async {
    try {
      await _sqliteUseCase(ref).createDatabase(name, version: version);
      await loadDatabases();
      return null;
    } on ArgumentError {
      return 'invalid_database_name';
    } on StateError catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> deleteDatabase(String fileName) async {
    try {
      await _sqliteUseCase(ref).deleteDatabase(fileName);
      await loadDatabases();
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> exportDatabase(String fileName) async {
    try {
      return await _sqliteUseCase(ref).exportDatabase(fileName);
    } on StateError catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> prepareDatabaseShare(String fileName) async {
    try {
      return await _sqliteUseCase(ref).prepareDatabaseShare(fileName);
    } on StateError catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> importDatabase(String sourcePath, String targetName) async {
    try {
      await _sqliteUseCase(ref).importDatabase(sourcePath, targetName);
      await loadDatabases();
      return null;
    } on ArgumentError {
      return 'invalid_database_name';
    } on StateError catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }
}

@riverpod
class SqliteDatabaseDetail extends _$SqliteDatabaseDetail {
  @override
  SqliteDatabaseDetailState build(String fileName) {
    Future.microtask(loadDetail);
    return SqliteDatabaseDetailState.initial(fileName);
  }

  Future<void> loadDetail() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final tables = await _sqliteUseCase(ref).loadTables(state.fileName);
      state = state.copyWith(
        isLoading: false,
        tables: tables
            .map(
              (table) =>
                  TableInfoView(name: table.name, rowCount: table.rowCount),
            )
            .toList(),
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> loadTables() => loadDetail();

  Future<String?> createTable(
    String tableName,
    List<ColumnDefinition> columns, {
    List<IndexDefinition> indexes = const [],
  }) async {
    try {
      await _sqliteUseCase(ref).createTable(
        state.fileName,
        tableName,
        columns,
        indexes: indexes,
      );
      await loadDetail();
      return null;
    } on ArgumentError catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }
}

@riverpod
class SqliteTableData extends _$SqliteTableData {
  @override
  SqliteTableDataState build({
    required String fileName,
    required String tableName,
  }) {
    Future.microtask(loadData);
    return SqliteTableDataState.initial(fileName: fileName, tableName: tableName);
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final schema = await _sqliteUseCase(
        ref,
      ).loadTableSchema(state.fileName, state.tableName);
      final rows = await _sqliteUseCase(
        ref,
      ).loadTableData(state.fileName, state.tableName);
      state = state.copyWith(
        isLoading: false,
        columns: schema.columns.map((column) => column.name).toList(),
        primaryKeyColumns: schema.primaryKeyColumns,
        rows: rows,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<String?> insertRow(Map<String, Object?> values) async {
    try {
      await _sqliteUseCase(
        ref,
      ).insertRow(state.fileName, state.tableName, values);
      await loadData();
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> updateRow(
    Map<String, Object?> values,
    Map<String, Object?> originalRow,
  ) async {
    try {
      final where = _sqliteUseCase(
        ref,
      ).buildRowWhere(originalRow, state.primaryKeyColumns);
      final count = await _sqliteUseCase(
        ref,
      ).updateRow(state.fileName, state.tableName, values, where);
      if (count == 0) {
        return 'update_failed';
      }
      await loadData();
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> deleteRow(Map<String, Object?> row) async {
    try {
      final where = _sqliteUseCase(
        ref,
      ).buildRowWhere(row, state.primaryKeyColumns);
      final count = await _sqliteUseCase(
        ref,
      ).deleteRow(state.fileName, state.tableName, where);
      if (count == 0) {
        return 'delete_failed';
      }
      await loadData();
      return null;
    } catch (error) {
      return error.toString();
    }
  }
}

@riverpod
class SqliteTableSchema extends _$SqliteTableSchema {
  @override
  SqliteTableSchemaState build({
    required String fileName,
    required String tableName,
  }) {
    Future.microtask(loadSchema);
    return SqliteTableSchemaState.initial(
      fileName: fileName,
      tableName: tableName,
    );
  }

  Future<void> loadSchema() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final schema = await _sqliteUseCase(
        ref,
      ).loadTableSchema(state.fileName, state.tableName);
      state = state.copyWith(isLoading: false, schema: schema, clearError: true);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<String?> addColumn(ColumnDefinition column) async {
    try {
      await _sqliteUseCase(
        ref,
      ).addColumn(state.fileName, state.tableName, column);
      await loadSchema();
      return null;
    } on ArgumentError catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }
}
