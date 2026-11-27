import 'dart:io';

/// SQLite DB import 파일 검증 유틸리티
class SqliteFileValidator {
  SqliteFileValidator._();

  static const _allowedExtensions = {'.db', '.sqlite', '.sqlite3'};
  static const _sqliteMagicHeader = 'SQLite format 3';

  static String _extension(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0) return '';
    return path.substring(dot).toLowerCase();
  }

  /// 확장자(.db, .sqlite, .sqlite3)로 DB 파일 여부 판별
  static bool isDbFileByName(String path, {String? displayName}) {
    if (_allowedExtensions.contains(_extension(path))) return true;
    if (displayName == null) return false;
    return _allowedExtensions.contains(_extension(displayName));
  }

  /// SQLite 매직 헤더("SQLite format 3") 검증
  static Future<bool> hasSqliteHeader(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return false;
      final bytes = await file.openRead(0, 16).first;
      if (bytes.length < 15) return false;
      return String.fromCharCodes(bytes.take(15)) == _sqliteMagicHeader;
    } catch (_) {
      return false;
    }
  }

  /// 확장자 또는 매직 헤더로 import 가능한 DB 파일인지 확인
  static Future<bool> isValidImportFile(
    String path, {
    String? displayName,
  }) async {
    if (isDbFileByName(path, displayName: displayName)) return true;
    return hasSqliteHeader(path);
  }
}
