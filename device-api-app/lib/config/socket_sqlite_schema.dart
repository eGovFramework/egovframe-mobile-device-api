import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Socket SQLite 연동 스키마 (MySQL SOCKET_MESSAGE 테이블과 동일 컬럼)
class SocketSqliteSchema {
  SocketSqliteSchema._();

  static const String tableName = AppConfig.socketTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'message',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'sender',
    'timestamp',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'socket_message',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
