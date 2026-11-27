/// 앱 공통 SQLite 설정.
class SqliteConfig {
  SqliteConfig._();

  static const String dbFileExtension = '.db';
  static const String backupFolder = 'sqlite_backups';

  /// Android MethodChannel 이름. MainActivity와 동일해야 합니다.
  static String downloadsMethodChannel = 'egovframe_mobile_deviceapi_app/downloads';

  static void Function(String message)? onLog;

  static void log(String message) => onLog?.call(message);
}
