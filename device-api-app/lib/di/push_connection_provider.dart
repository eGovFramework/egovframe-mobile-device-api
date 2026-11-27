import 'package:egovframe_mobile_deviceapi_app/data/push/datasources/push_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class PushConnection extends _$PushConnection {
  @override
  PushConnectionState build() => const PushConnectionState();

  void useServer() {
    state = const PushConnectionState(mode: PushConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = PushConnectionState(
      mode: PushConnectionMode.sqlite,
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
PushSqliteService pushSqliteService(Ref ref) =>
    PushSqliteService(ref.watch(featureTableServiceProvider));
