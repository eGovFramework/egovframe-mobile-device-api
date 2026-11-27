import 'package:egovframe_mobile_deviceapi_app/data/media/datasources/media_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class MediaConnection extends _$MediaConnection {
  @override
  MediaConnectionState build() => const MediaConnectionState();

  void useServer() {
    state = const MediaConnectionState(mode: MediaConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = MediaConnectionState(
      mode: MediaConnectionMode.sqlite,
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
MediaSqliteService mediaSqliteService(Ref ref) =>
    MediaSqliteService(ref.watch(featureTableServiceProvider));
