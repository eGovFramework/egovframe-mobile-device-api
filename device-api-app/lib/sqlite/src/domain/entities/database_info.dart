/// 내부 SQLite 데이터베이스 파일 정보
class DatabaseInfo {
  final String fileName;
  final String path;
  final int sizeBytes;
  final DateTime modifiedAt;
  final int version;

  const DatabaseInfo({
    required this.fileName,
    required this.path,
    required this.sizeBytes,
    required this.modifiedAt,
    this.version = 1,
  });

  String get displayName => fileName.replaceAll('.db', '');
}
