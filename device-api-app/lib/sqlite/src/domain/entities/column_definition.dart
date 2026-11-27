/// SQLite 컬럼 정의
class ColumnDefinition {
  final String name;
  final SqliteColumnType type;
  final bool isPrimaryKey;
  final bool notNull;
  final bool autoIncrement;
  final bool unique;
  final String? defaultValue;
  final String? foreignKeyTable;
  final String? foreignKeyColumn;
  final ForeignKeyAction onDelete;
  final ForeignKeyAction onUpdate;

  const ColumnDefinition({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.notNull = false,
    this.autoIncrement = false,
    this.unique = false,
    this.defaultValue,
    this.foreignKeyTable,
    this.foreignKeyColumn,
    this.onDelete = ForeignKeyAction.noAction,
    this.onUpdate = ForeignKeyAction.noAction,
  });

  bool get hasForeignKey =>
      foreignKeyTable != null &&
      foreignKeyTable!.isNotEmpty &&
      foreignKeyColumn != null &&
      foreignKeyColumn!.isNotEmpty;

  String toSqlFragment() {
    final buffer = StringBuffer('$name ${type.sqlName}');

    if (isPrimaryKey) {
      buffer.write(' PRIMARY KEY');
      if (autoIncrement) {
        buffer.write(' AUTOINCREMENT');
      }
    }

    if (!isPrimaryKey && notNull) {
      buffer.write(' NOT NULL');
    }

    if (unique && !isPrimaryKey) {
      buffer.write(' UNIQUE');
    }

    if (defaultValue != null && defaultValue!.isNotEmpty) {
      buffer.write(' DEFAULT ${_quoteDefault(defaultValue!)}');
    }

    if (hasForeignKey) {
      buffer.write(
        ' REFERENCES "$foreignKeyTable"("$foreignKeyColumn")'
        ' ON DELETE ${onDelete.sql}'
        ' ON UPDATE ${onUpdate.sql}',
      );
    }

    return buffer.toString();
  }

  String toAlterAddSql() {
    final buffer = StringBuffer(type.sqlName);

    if (notNull) {
      buffer.write(' NOT NULL');
    }
    if (unique) {
      buffer.write(' UNIQUE');
    }
    if (defaultValue != null && defaultValue!.isNotEmpty) {
      buffer.write(' DEFAULT ${_quoteDefault(defaultValue!)}');
    }

    return buffer.toString();
  }

  static String _quoteDefault(String value) {
    if (value == 'NULL') return 'NULL';
    if (RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value)) return value;
    if (value.startsWith("'") && value.endsWith("'")) return value;
    return "'$value'";
  }
}

enum SqliteColumnType {
  integer('INTEGER'),
  text('TEXT'),
  real('REAL'),
  blob('BLOB'),
  numeric('NUMERIC');

  const SqliteColumnType(this.sqlName);
  final String sqlName;

  static SqliteColumnType fromSql(String raw) {
    final upper = raw.toUpperCase();
    for (final type in SqliteColumnType.values) {
      if (upper.startsWith(type.sqlName)) return type;
    }
    return SqliteColumnType.text;
  }
}

enum ForeignKeyAction {
  noAction('NO ACTION'),
  restrict('RESTRICT'),
  setNull('SET NULL'),
  setDefault('SET DEFAULT'),
  cascade('CASCADE');

  const ForeignKeyAction(this.sql);
  final String sql;
}
