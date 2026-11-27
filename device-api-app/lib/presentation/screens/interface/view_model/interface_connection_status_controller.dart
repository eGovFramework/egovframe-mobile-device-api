import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/interface/datasources/interface_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/interface_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interface_connection_status_controller.g.dart';

class InterfaceConnectionStatusSnapshot {
  final InterfaceDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const InterfaceConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class InterfaceConnectionStatus extends _$InterfaceConnectionStatus {
  final InterfaceServerConnectionService _networkService =
      InterfaceServerConnectionService();

  @override
  Future<InterfaceConnectionStatusSnapshot> build() async {
    ref.watch(interfaceConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<InterfaceConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(interfaceConnectionProvider);
    final sqliteService = ref.read(interfaceSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return InterfaceConnectionStatusSnapshot(
          activeSource: InterfaceDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return InterfaceConnectionStatusSnapshot(
        activeSource: InterfaceDataSourceStatus.externalServer,
        statusDetail: AppConfig.interfaceServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return InterfaceConnectionStatusSnapshot(
      activeSource: InterfaceDataSourceStatus.disconnected,
      statusDetail: AppConfig.interfaceServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
