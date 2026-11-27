import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Compass SQLite 연동 스키마 (MySQL COMPASS 테이블과 동일 컬럼)
class CompassSqliteSchema {
  CompassSqliteSchema._();

  static const String tableName = AppConfig.compassTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'drc',
    'accrcy',
    'timestamp',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'compass',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
