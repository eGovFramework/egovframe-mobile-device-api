import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// IoT MQTT 메시지 SQLite 스키마 (MySQL IOT_MESSAGE와 동일 컬럼)
class IotSqliteSchema {
  IotSqliteSchema._();

  static const String tableName = AppConfig.iotTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'topic',
    'payload',
    'direction',
    'messageType',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'timestamp',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'iot_message',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
