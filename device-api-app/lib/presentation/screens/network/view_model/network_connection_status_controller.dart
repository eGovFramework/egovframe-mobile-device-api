import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/network_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_connection_status_controller.g.dart';

class NetworkConnectionStatusSnapshot {
  final NetworkDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const NetworkConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class NetworkConnectionStatus extends _$NetworkConnectionStatus {
  final NetworkServerConnectionService _networkService = NetworkServerConnectionService();

  @override
  Future<NetworkConnectionStatusSnapshot> build() async {
    ref.watch(networkConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<NetworkConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(networkConnectionProvider);
    final sqliteService = ref.read(networkSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return NetworkConnectionStatusSnapshot(
          activeSource: NetworkDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return NetworkConnectionStatusSnapshot(
        activeSource: NetworkDataSourceStatus.externalServer,
        statusDetail: AppConfig.networkServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return NetworkConnectionStatusSnapshot(
      activeSource: NetworkDataSourceStatus.disconnected,
      statusDetail: AppConfig.networkServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
