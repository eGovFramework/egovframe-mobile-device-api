import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// AI Chat SQLite 연동 스키마 (MySQL AI_CHAT_INFO 테이블과 동일 컬럼)
class AiChatSqliteSchema {
  AiChatSqliteSchema._();

  static const String tableName = AppConfig.aiChatTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'question',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'answer',
    'chatMode',
    'modelNm',
    'sessionId',
    'questionTimestamp',
    'answerTimestamp',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'aiChat',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
