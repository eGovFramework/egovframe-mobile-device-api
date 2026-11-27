import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileopener/datasources/file_opener_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/fileopener_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/fileopener_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fileopener_connection_status_controller.g.dart';

class FileOpenerConnectionStatusSnapshot {
  final FileOpenerDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const FileOpenerConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class FileOpenerConnectionStatus extends _$FileOpenerConnectionStatus {
  final FileOpenerServerConnectionService _networkService =
      FileOpenerServerConnectionService();

  @override
  Future<FileOpenerConnectionStatusSnapshot> build() async {
    ref.watch(fileOpenerConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<FileOpenerConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(fileOpenerConnectionProvider);
    final sqliteService = ref.read(fileOpenerSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return FileOpenerConnectionStatusSnapshot(
          activeSource: FileOpenerDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return FileOpenerConnectionStatusSnapshot(
        activeSource: FileOpenerDataSourceStatus.externalServer,
        statusDetail: AppConfig.fileOpenerServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return FileOpenerConnectionStatusSnapshot(
      activeSource: FileOpenerDataSourceStatus.disconnected,
      statusDetail: AppConfig.fileOpenerServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
