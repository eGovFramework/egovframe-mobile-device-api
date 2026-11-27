import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Device SQLite 연동 스키마 (MySQL DEVICE 테이블과 동일 컬럼)
class DeviceSqliteSchema {
  DeviceSqliteSchema._();

  static const String tableName = AppConfig.deviceTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'os',
    'ntwrkDeviceInfo',
    'pgVer',
    'deviceNm',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'telno',
    'strgeInfo',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'device_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
