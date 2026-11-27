import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Network SQLite 연동 스키마
class NetworkSqliteSchema {
  NetworkSqliteSchema._();

  static const String tableName = AppConfig.networkTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'networktype',
    'timestamp',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'network_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
