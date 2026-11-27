import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// File Opener SQLite 연동 스키마 (MySQL FILE_OPENER_LIST + FILE_DETAIL_INFO)
class FileOpenerSqliteSchema {
  FileOpenerSqliteSchema._();

  static const String tableName = AppConfig.fileOpenerTableName;

  static const Set<String> requiredColumns = {
    'fileSn',
    'streFileNm',
    'orignlFileNm',
    'updDt',
    'fileSize',
  };

  static const Set<String> optionalColumns = {
    'useYn',
    'localPath',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'file_opener_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
