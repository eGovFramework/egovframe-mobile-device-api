import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/media/datasources/media_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/media_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_connection_status_controller.g.dart';

class MediaConnectionStatusSnapshot {
  final MediaDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const MediaConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class MediaConnectionStatus extends _$MediaConnectionStatus {
  final MediaServerConnectionService _networkService =
      MediaServerConnectionService();

  @override
  Future<MediaConnectionStatusSnapshot> build() async {
    ref.watch(mediaConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<MediaConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(mediaConnectionProvider);
    final sqliteService = ref.read(mediaSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return MediaConnectionStatusSnapshot(
          activeSource: MediaDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return MediaConnectionStatusSnapshot(
        activeSource: MediaDataSourceStatus.externalServer,
        statusDetail: AppConfig.mediaServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return MediaConnectionStatusSnapshot(
      activeSource: MediaDataSourceStatus.disconnected,
      statusDetail: AppConfig.mediaServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
