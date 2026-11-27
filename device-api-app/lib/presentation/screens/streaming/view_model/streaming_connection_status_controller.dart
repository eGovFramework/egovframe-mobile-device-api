import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/streaming/datasources/streaming_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/streaming_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streaming_connection_status_controller.g.dart';

class StreamingConnectionStatusSnapshot {
  final StreamingDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const StreamingConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class StreamingConnectionStatus extends _$StreamingConnectionStatus {
  final StreamingServerConnectionService _networkService = StreamingServerConnectionService();

  @override
  Future<StreamingConnectionStatusSnapshot> build() async {
    ref.watch(streamingConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<StreamingConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(streamingConnectionProvider);
    final sqliteService = ref.read(streamingSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return StreamingConnectionStatusSnapshot(
          activeSource: StreamingDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return StreamingConnectionStatusSnapshot(
        activeSource: StreamingDataSourceStatus.externalServer,
        statusDetail: AppConfig.streamingServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return StreamingConnectionStatusSnapshot(
      activeSource: StreamingDataSourceStatus.disconnected,
      statusDetail: AppConfig.streamingServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
