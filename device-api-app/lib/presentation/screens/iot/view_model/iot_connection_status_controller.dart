import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/iot_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iot_connection_status_controller.g.dart';

@riverpod
class IotConnectionStatus extends _$IotConnectionStatus {
  final IotServerConnectionService _networkService =
      IotServerConnectionService();

  @override
  Future<IotDataSourceSnapshot> build() async {
    ref.watch(iotConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<IotDataSourceSnapshot> _loadSnapshot() async {
    final connection = ref.read(iotConnectionProvider);
    final sqliteService = ref.read(iotSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return IotDataSourceSnapshot(
          kind: IotDataSourceKind.sqlite,
          reachable: serverReachable,
          sqliteReady: true,
          sqliteToggleOn: true,
          readyDatabases: readyDatabases,
          selectedDbFileName: connection.sqliteDbFileName,
        );
      }
    }

    if (serverReachable) {
      return IotDataSourceSnapshot(
        kind: IotDataSourceKind.server,
        reachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
        selectedDbFileName: connection.sqliteDbFileName,
      );
    }

    return IotDataSourceSnapshot(
      kind: IotDataSourceKind.server,
      reachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
      selectedDbFileName: connection.sqliteDbFileName,
    );
  }
}
