import 'column_definition.dart';

/// PRAGMA table_info 결과
class ColumnInfo {
  final int cid;
  final String name;
  final SqliteColumnType type;
  final bool notNull;
  final Object? defaultValue;
  final bool isPrimaryKey;

  const ColumnInfo({
    required this.cid,
    required this.name,
    required this.type,
    required this.notNull,
    this.defaultValue,
    this.isPrimaryKey = false,
  });

  factory ColumnInfo.fromPragma(Map<String, Object?> row) {
    final typeName = (row['type'] as String? ?? 'TEXT').toUpperCase();
    return ColumnInfo(
      cid: row['cid'] as int? ?? 0,
      name: row['name'] as String? ?? '',
      type: SqliteColumnType.fromSql(typeName),
      notNull: (row['notnull'] as int? ?? 0) == 1,
      defaultValue: row['dflt_value'],
      isPrimaryKey: (row['pk'] as int? ?? 0) > 0,
    );
  }
}
