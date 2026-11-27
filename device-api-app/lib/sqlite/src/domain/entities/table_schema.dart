import 'column_info.dart';

class TableSchema {
  final String tableName;
  final List<ColumnInfo> columns;
  final List<String> indexes;

  const TableSchema({
    required this.tableName,
    required this.columns,
    required this.indexes,
  });

  List<String> get primaryKeyColumns =>
      columns.where((c) => c.isPrimaryKey).map((c) => c.name).toList();
}
