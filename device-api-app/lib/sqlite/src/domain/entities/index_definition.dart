/// SQLite 인덱스 정의
class IndexDefinition {
  final String name;
  final List<String> columns;
  final bool unique;

  const IndexDefinition({
    required this.name,
    required this.columns,
    this.unique = false,
  });

  String toCreateSql(String tableName) {
    final uniqueKeyword = unique ? 'UNIQUE ' : '';
    final columnList = columns.map((c) => '"$c"').join(', ');
    return 'CREATE ${uniqueKeyword}INDEX IF NOT EXISTS "$name" '
        'ON "$tableName" ($columnList)';
  }
}
