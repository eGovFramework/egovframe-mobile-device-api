import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Interface SQLite 연동 스키마 (MySQL INTERFACE_EGOV 테이블과 동일 컬럼)
class InterfaceSqliteSchema {
  InterfaceSqliteSchema._();

  static const String tableName = AppConfig.interfaceTableName;

  static const Set<String> requiredColumns = {
    'userId',
    'userPw',
    'emails',
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = <String>{};

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'interface_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
