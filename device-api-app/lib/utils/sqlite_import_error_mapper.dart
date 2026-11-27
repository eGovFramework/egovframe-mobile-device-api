import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';

/// SQLite import/생성 오류 코드를 사용자 메시지로 변환
String mapSqliteImportError(AppLocalizations l10n, Object error) {
  final code = switch (error) {
    ArgumentError(:final message) => message,
    StateError(:final message) => message,
    _ => error.toString(),
  };

  return switch (code) {
    'invalid_database_name' => l10n.commonSqliteInvalidDatabaseName,
    'database_already_exists' => l10n.commonSqliteDatabaseAlreadyExists,
    'import_file_not_found' => l10n.commonSqliteImportFileNotFound,
    _ => code,
  };
}
