import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/fileReadWrite/datasources/file_readwrite_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/file_readwrite_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_readwrite_connection_status_controller.g.dart';

class FileReadWriteConnectionStatusSnapshot {
  final FileReadWriteDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const FileReadWriteConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class FileReadWriteConnectionStatus extends _$FileReadWriteConnectionStatus {
  final FileReadWriteServerConnectionService _networkService =
      FileReadWriteServerConnectionService();

  @override
  Future<FileReadWriteConnectionStatusSnapshot> build() async {
    ref.watch(fileReadWriteConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<FileReadWriteConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(fileReadWriteConnectionProvider);
    final sqliteService = ref.read(fileReadWriteSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return FileReadWriteConnectionStatusSnapshot(
          activeSource: FileReadWriteDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return FileReadWriteConnectionStatusSnapshot(
        activeSource: FileReadWriteDataSourceStatus.externalServer,
        statusDetail: AppConfig.fileReadWriteServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return FileReadWriteConnectionStatusSnapshot(
      activeSource: FileReadWriteDataSourceStatus.disconnected,
      statusDetail: AppConfig.fileReadWriteServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
