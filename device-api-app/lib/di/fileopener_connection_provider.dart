import 'package:egovframe_mobile_deviceapi_app/data/fileopener/datasources/file_opener_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fileopener_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class FileOpenerConnection extends _$FileOpenerConnection {
  @override
  FileOpenerConnectionState build() => const FileOpenerConnectionState();

  void useServer() {
    state =
        const FileOpenerConnectionState(mode: FileOpenerConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = FileOpenerConnectionState(
      mode: FileOpenerConnectionMode.sqlite,
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
FileOpenerSqliteService fileOpenerSqliteService(Ref ref) =>
    FileOpenerSqliteService(ref.watch(featureTableServiceProvider));
