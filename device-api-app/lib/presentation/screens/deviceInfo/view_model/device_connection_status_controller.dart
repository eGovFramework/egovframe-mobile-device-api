import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/deviceInfo/datasources/device_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/device_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_connection_status_controller.g.dart';

class DeviceConnectionStatusSnapshot {
  final DeviceDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const DeviceConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class DeviceConnectionStatus extends _$DeviceConnectionStatus {
  final DeviceServerConnectionService _networkService =
      DeviceServerConnectionService();

  @override
  Future<DeviceConnectionStatusSnapshot> build() async {
    ref.watch(deviceConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<DeviceConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(deviceConnectionProvider);
    final sqliteService = ref.read(deviceSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return DeviceConnectionStatusSnapshot(
          activeSource: DeviceDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return DeviceConnectionStatusSnapshot(
        activeSource: DeviceDataSourceStatus.externalServer,
        statusDetail: AppConfig.deviceServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return DeviceConnectionStatusSnapshot(
      activeSource: DeviceDataSourceStatus.disconnected,
      statusDetail: AppConfig.deviceServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
