import 'package:egovframe_mobile_deviceapi_app/data/streaming/datasources/streaming_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streaming_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class StreamingConnection extends _$StreamingConnection {
  @override
  StreamingConnectionState build() => const StreamingConnectionState();

  void useServer() {
    state = const StreamingConnectionState(mode: StreamingConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = StreamingConnectionState(
      mode: StreamingConnectionMode.sqlite,
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
StreamingSqliteService streamingSqliteService(Ref ref) =>
    StreamingSqliteService(
      ref.watch(featureTableServiceProvider),
      ref.watch(sqliteServiceProvider),
    );
