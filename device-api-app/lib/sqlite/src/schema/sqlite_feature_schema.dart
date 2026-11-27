/// 기능 앱(DeviceInfo 등)이 SQLite에 사용하는 테이블 메타데이터.
class SqliteFeatureSchema {
  final String featureId;
  final String tableName;
  final Set<String> requiredColumns;
  final Set<String> optionalColumns;

  const SqliteFeatureSchema({
    required this.featureId,
    required this.tableName,
    required this.requiredColumns,
    this.optionalColumns = const {},
  });
}

enum SqliteSetupStatus {
  ready,
  noDatabase,
  noFeatureTable,
}
