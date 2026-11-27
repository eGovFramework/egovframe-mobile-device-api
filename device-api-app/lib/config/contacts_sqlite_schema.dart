import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Contacts SQLite 연동 스키마 (MySQL CONTACT_INFO 테이블과 동일 컬럼)
class ContactsSqliteSchema {
  ContactsSqliteSchema._();

  static const String tableName = AppConfig.contactsTableName;

  static const Set<String> requiredColumns = {
    'sn',
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'name',
    'telno',
    'emails',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'contact_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
