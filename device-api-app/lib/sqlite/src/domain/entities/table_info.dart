/// SQLite 테이블 메타 정보
class TableInfo {
  final String name;
  final int rowCount;

  const TableInfo({
    required this.name,
    required this.rowCount,
  });
}
