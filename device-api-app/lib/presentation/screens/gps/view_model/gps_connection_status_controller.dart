import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/gps/datasources/gps_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/gps_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gps_connection_status_controller.g.dart';

class GpsConnectionStatusSnapshot {
  final GpsDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const GpsConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class GpsConnectionStatus extends _$GpsConnectionStatus {
  final GpsServerConnectionService _networkService = GpsServerConnectionService();

  @override
  Future<GpsConnectionStatusSnapshot> build() async {
    ref.watch(gpsConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<GpsConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(gpsConnectionProvider);
    final sqliteService = ref.read(gpsSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return GpsConnectionStatusSnapshot(
          activeSource: GpsDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return GpsConnectionStatusSnapshot(
        activeSource: GpsDataSourceStatus.externalServer,
        statusDetail: AppConfig.gpsServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return GpsConnectionStatusSnapshot(
      activeSource: GpsDataSourceStatus.disconnected,
      statusDetail: AppConfig.gpsServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
