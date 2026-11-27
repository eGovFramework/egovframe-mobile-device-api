import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Accelerator SQLite 연동 스키마
class AcceleratorSqliteSchema {
  AcceleratorSqliteSchema._();

  static const String tableName = AppConfig.acceleratorTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'xaxis',
    'yaxis',
    'zaxis',
    'timestamp',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'accelerator_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
