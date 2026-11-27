import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

class SqliteMainState {
  final List<DatabaseInfo> databases;
  final bool isLoading;
  final String? errorMessage;

  const SqliteMainState({
    this.databases = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  factory SqliteMainState.initial() => const SqliteMainState(isLoading: true);

  SqliteMainState copyWith({
    List<DatabaseInfo>? databases,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SqliteMainState(
      databases: databases ?? this.databases,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class SqliteDatabaseDetailState {
  final String fileName;
  final List<TableInfoView> tables;
  final bool isLoading;
  final String? errorMessage;

  const SqliteDatabaseDetailState({
    required this.fileName,
    this.tables = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  factory SqliteDatabaseDetailState.initial(String fileName) =>
      SqliteDatabaseDetailState(fileName: fileName, isLoading: true);

  SqliteDatabaseDetailState copyWith({
    List<TableInfoView>? tables,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SqliteDatabaseDetailState(
      fileName: fileName,
      tables: tables ?? this.tables,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class TableInfoView {
  final String name;
  final int rowCount;

  const TableInfoView({required this.name, required this.rowCount});
}

class SqliteTableDataState {
  final String fileName;
  final String tableName;
  final List<String> columns;
  final List<String> primaryKeyColumns;
  final List<Map<String, Object?>> rows;
  final bool isLoading;
  final String? errorMessage;

  const SqliteTableDataState({
    required this.fileName,
    required this.tableName,
    this.columns = const [],
    this.primaryKeyColumns = const [],
    this.rows = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  factory SqliteTableDataState.initial({
    required String fileName,
    required String tableName,
  }) => SqliteTableDataState(
    fileName: fileName,
    tableName: tableName,
    isLoading: true,
  );

  List<String> get displayColumns =>
      columns.where((column) => column != '__rowid__').toList();

  SqliteTableDataState copyWith({
    List<String>? columns,
    List<String>? primaryKeyColumns,
    List<Map<String, Object?>>? rows,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SqliteTableDataState(
      fileName: fileName,
      tableName: tableName,
      columns: columns ?? this.columns,
      primaryKeyColumns: primaryKeyColumns ?? this.primaryKeyColumns,
      rows: rows ?? this.rows,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class SqliteTableSchemaState {
  final String fileName;
  final String tableName;
  final TableSchema? schema;
  final bool isLoading;
  final String? errorMessage;

  const SqliteTableSchemaState({
    required this.fileName,
    required this.tableName,
    this.schema,
    this.isLoading = false,
    this.errorMessage,
  });

  factory SqliteTableSchemaState.initial({
    required String fileName,
    required String tableName,
  }) => SqliteTableSchemaState(
    fileName: fileName,
    tableName: tableName,
    isLoading: true,
  );

  SqliteTableSchemaState copyWith({
    TableSchema? schema,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SqliteTableSchemaState(
      fileName: fileName,
      tableName: tableName,
      schema: schema ?? this.schema,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
