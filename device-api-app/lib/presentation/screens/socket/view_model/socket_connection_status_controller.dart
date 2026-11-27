import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/socket/datasources/socket_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/socket_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'socket_connection_status_controller.g.dart';

class SocketConnectionStatusSnapshot {
  final SocketDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const SocketConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class SocketConnectionStatus extends _$SocketConnectionStatus {
  final SocketServerConnectionService _networkService = SocketServerConnectionService();

  @override
  Future<SocketConnectionStatusSnapshot> build() async {
    ref.watch(socketConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<SocketConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(socketConnectionProvider);
    final sqliteService = ref.read(socketSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return SocketConnectionStatusSnapshot(
          activeSource: SocketDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return SocketConnectionStatusSnapshot(
        activeSource: SocketDataSourceStatus.externalServer,
        statusDetail: AppConfig.socketServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return SocketConnectionStatusSnapshot(
      activeSource: SocketDataSourceStatus.disconnected,
      statusDetail: AppConfig.socketServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
