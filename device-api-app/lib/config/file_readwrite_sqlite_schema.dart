import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';

/// File ReadWrite SQLite 연동 스키마 (MySQL FILE_READER_WRITE)
class FileReadWriteSqliteSchema {
  FileReadWriteSqliteSchema._();

  static const String tableName = AppConfig.fileReadWriteTableName;

  static const Set<String> requiredColumns = {
    'uuid',
    'useYn',
  };

  static const Set<String> optionalColumns = {
    'sn',
    'fileSn',
    'fileNm',
    'fileName',
    'fileStreCours',
    'streFileNm',
    'orignlFileNm',
    'fileExtsn',
    'fileCn',
    'fileSize',
    'updtDt',
  };

  static const SqliteFeatureSchema schema = SqliteFeatureSchema(
    featureId: 'file_reader_writer_info',
    tableName: tableName,
    requiredColumns: requiredColumns,
    optionalColumns: optionalColumns,
  );
}
