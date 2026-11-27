import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// Barcode SQLite 연동 스키마 (MySQL BARCODE_INFO 테이블과 동일 컬럼)
class BarcodeSqliteSchema {
  BarcodeSqliteSchema._();

  static const String tableName = AppConfig.barcodeTableName;

  static const Set<String> requiredColumns = {
    'codeType',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'codeText',
    'codeDt',
    'uuid',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'barcode_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
