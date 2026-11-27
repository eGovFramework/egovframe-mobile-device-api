import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/datasources/file_readwrite_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_readwrite_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class FileReadWriteConnection extends _$FileReadWriteConnection {
  @override
  FileReadWriteConnectionState build() => const FileReadWriteConnectionState();

  void useServer() {
    state = const FileReadWriteConnectionState(
      mode: FileReadWriteConnectionMode.server,
    );
  }

  void useSqlite(String dbFileName) {
    state = FileReadWriteConnectionState(
      mode: FileReadWriteConnectionMode.sqlite,
      sqliteDbFileName: dbFileName,
    );
  }
}

@Riverpod(keepAlive: true)
SqliteService sqliteService(Ref ref) => SqliteService();

@Riverpod(keepAlive: true)
FeatureTableService featureTableService(Ref ref) =>
    FeatureTableService(ref.watch(sqliteServiceProvider));

@Riverpod(keepAlive: true)
FileReadWriteSqliteService fileReadWriteSqliteService(Ref ref) =>
    FileReadWriteSqliteService(ref.watch(featureTableServiceProvider));
