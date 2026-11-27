import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// StreamingMedia SQLite 연동 스키마 (MySQL MEDIA 테이블과 동일 컬럼)
class StreamingSqliteSchema {
  StreamingSqliteSchema._();

  static const String tableName = AppConfig.streamingTableName;

  static const Set<String> requiredColumns = {
    'mdSj',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'mdCode',
    'revivCo',
    'fileSn',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'media',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
