import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Media SQLite 연동 스키마 (MySQL MEDIA + FILE_DETAIL_INFO 조인 컬럼)
/// Streaming의 `MEDIA` 테이블과 구분한다.
class MediaSqliteSchema {
  MediaSqliteSchema._();

  static const String tableName = AppConfig.mediaInfoTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'fileSn',
    'mdCode',
    'mdSj',
    'revivCo',
    'fileStreCours',
    'streFileNm',
    'orignlFileNm',
    'fileExtsn',
    'fileCn',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'media_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
