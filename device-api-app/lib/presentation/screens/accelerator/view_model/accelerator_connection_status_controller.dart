import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/accelerator/datasources/accelerator_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/accelerator_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accelerator_connection_status_controller.g.dart';

class AcceleratorConnectionStatusSnapshot {
  final AcceleratorDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const AcceleratorConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class AcceleratorConnectionStatus extends _$AcceleratorConnectionStatus {
  final AcceleratorServerConnectionService _networkService = AcceleratorServerConnectionService();

  @override
  Future<AcceleratorConnectionStatusSnapshot> build() async {
    ref.watch(acceleratorConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<AcceleratorConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(acceleratorConnectionProvider);
    final sqliteService = ref.read(acceleratorSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return AcceleratorConnectionStatusSnapshot(
          activeSource: AcceleratorDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return AcceleratorConnectionStatusSnapshot(
        activeSource: AcceleratorDataSourceStatus.externalServer,
        statusDetail: AppConfig.acceleratorServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return AcceleratorConnectionStatusSnapshot(
      activeSource: AcceleratorDataSourceStatus.disconnected,
      statusDetail: AppConfig.acceleratorServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
