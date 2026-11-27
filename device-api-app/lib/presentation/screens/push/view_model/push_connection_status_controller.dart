import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/push/datasources/push_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/push_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_connection_status_controller.g.dart';

class PushConnectionStatusSnapshot {
  final PushDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const PushConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class PushConnectionStatus extends _$PushConnectionStatus {
  final PushServerConnectionService _networkService = PushServerConnectionService();

  @override
  Future<PushConnectionStatusSnapshot> build() async {
    ref.watch(pushConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<PushConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(pushConnectionProvider);
    final sqliteService = ref.read(pushSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return PushConnectionStatusSnapshot(
          activeSource: PushDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return PushConnectionStatusSnapshot(
        activeSource: PushDataSourceStatus.externalServer,
        statusDetail: AppConfig.pushServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return PushConnectionStatusSnapshot(
      activeSource: PushDataSourceStatus.disconnected,
      statusDetail: AppConfig.pushServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
