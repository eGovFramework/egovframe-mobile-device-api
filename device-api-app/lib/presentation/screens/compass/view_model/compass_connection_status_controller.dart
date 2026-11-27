import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/compass/datasources/compass_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/compass_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compass_connection_status_controller.g.dart';

class CompassConnectionStatusSnapshot {
  final CompassDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const CompassConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class CompassConnectionStatus extends _$CompassConnectionStatus {
  final CompassServerConnectionService _networkService = CompassServerConnectionService();

  @override
  Future<CompassConnectionStatusSnapshot> build() async {
    ref.watch(compassConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<CompassConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(compassConnectionProvider);
    final sqliteService = ref.read(compassSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return CompassConnectionStatusSnapshot(
          activeSource: CompassDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return CompassConnectionStatusSnapshot(
        activeSource: CompassDataSourceStatus.externalServer,
        statusDetail: AppConfig.compassServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return CompassConnectionStatusSnapshot(
      activeSource: CompassDataSourceStatus.disconnected,
      statusDetail: AppConfig.compassServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
