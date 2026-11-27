import 'package:egovframe_mobile_deviceapi_app/data/socket/datasources/socket_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'socket_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class SocketConnection extends _$SocketConnection {
  @override
  SocketConnectionState build() => const SocketConnectionState();

  void useServer() {
    state = const SocketConnectionState(mode: SocketConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = SocketConnectionState(
      mode: SocketConnectionMode.sqlite,
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
SocketSqliteService socketSqliteService(Ref ref) =>
    SocketSqliteService(ref.watch(featureTableServiceProvider));
