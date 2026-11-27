import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/datasources/face_mesh_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/face_mesh_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'face_mesh_connection_status_controller.g.dart';

class FaceMeshConnectionStatusSnapshot {
  final FaceMeshDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const FaceMeshConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class FaceMeshConnectionStatus extends _$FaceMeshConnectionStatus {
  final FaceMeshServerConnectionService _networkService =
      FaceMeshServerConnectionService();

  @override
  Future<FaceMeshConnectionStatusSnapshot> build() async {
    ref.watch(faceMeshConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<FaceMeshConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(faceMeshConnectionProvider);
    final sqliteService = ref.read(faceMeshSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup =
          await sqliteService.validateSetup(connection.sqliteDbFileName!);
      if (setup == SqliteSetupStatus.ready) {
        return FaceMeshConnectionStatusSnapshot(
          activeSource: FaceMeshDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return FaceMeshConnectionStatusSnapshot(
        activeSource: FaceMeshDataSourceStatus.externalServer,
        statusDetail: AppConfig.faceMeshServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return FaceMeshConnectionStatusSnapshot(
      activeSource: FaceMeshDataSourceStatus.disconnected,
      statusDetail: AppConfig.faceMeshServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
