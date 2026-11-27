import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Push SQLite 연동 스키마 (MySQL PUSH_DEVICE 테이블과 동일 컬럼)
class PushSqliteSchema {
  PushSqliteSchema._();

  static const String tableName = AppConfig.pushTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'ntwrkDeviceInfo',
    'osVer',
    'deviceNm',
    'osType',
    'tokenId',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'push_device',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
