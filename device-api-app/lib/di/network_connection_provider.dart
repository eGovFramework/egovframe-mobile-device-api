import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class NetworkConnection extends _$NetworkConnection {
  @override
  NetworkConnectionState build() => const NetworkConnectionState();

  void useServer() {
    state = const NetworkConnectionState(mode: NetworkConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = NetworkConnectionState(
      mode: NetworkConnectionMode.sqlite,
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
NetworkSqliteService networkSqliteService(Ref ref) =>
    NetworkSqliteService(ref.watch(featureTableServiceProvider));
