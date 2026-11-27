import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/aiChat/datasources/ai_chat_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/ai_chat_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_data_source_status.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_chat_connection_status_controller.g.dart';

class AiChatConnectionStatusSnapshot {
  final AiChatDataSourceStatus activeSource;
  final String statusDetail;
  final bool serverReachable;
  final bool sqliteToggleOn;
  final bool sqliteReady;
  final List<String> readyDatabases;

  const AiChatConnectionStatusSnapshot({
    required this.activeSource,
    required this.statusDetail,
    required this.serverReachable,
    required this.sqliteToggleOn,
    required this.sqliteReady,
    required this.readyDatabases,
  });
}

@riverpod
class AiChatConnectionStatus extends _$AiChatConnectionStatus {
  final AiChatServerConnectionService _networkService =
      AiChatServerConnectionService();

  @override
  Future<AiChatConnectionStatusSnapshot> build() async {
    ref.watch(aiChatConnectionProvider);
    return _loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadSnapshot());
  }

  Future<AiChatConnectionStatusSnapshot> _loadSnapshot() async {
    final connection = ref.read(aiChatConnectionProvider);
    final sqliteService = ref.read(aiChatSqliteServiceProvider);
    final readyDatabases = await sqliteService.findDatabasesWithFeatureTable();
    final serverReachable = await _networkService.isServerConnected();

    final sqliteToggleOn = connection.isSqlite;
    final sqliteReady = readyDatabases.isNotEmpty;

    if (sqliteToggleOn && connection.sqliteDbFileName != null) {
      final setup = await sqliteService.validateSetup(
        connection.sqliteDbFileName!,
      );
      if (setup == SqliteSetupStatus.ready) {
        return AiChatConnectionStatusSnapshot(
          activeSource: AiChatDataSourceStatus.sqlite,
          statusDetail: connection.sqliteDbFileName!,
          serverReachable: serverReachable,
          sqliteToggleOn: true,
          sqliteReady: true,
          readyDatabases: readyDatabases,
        );
      }
    }

    if (serverReachable) {
      return AiChatConnectionStatusSnapshot(
        activeSource: AiChatDataSourceStatus.externalServer,
        statusDetail: AppConfig.aiChatServerBaseUrl,
        serverReachable: true,
        sqliteToggleOn: sqliteToggleOn,
        sqliteReady: sqliteReady,
        readyDatabases: readyDatabases,
      );
    }

    return AiChatConnectionStatusSnapshot(
      activeSource: AiChatDataSourceStatus.disconnected,
      statusDetail: AppConfig.aiChatServerBaseUrl,
      serverReachable: false,
      sqliteToggleOn: sqliteToggleOn,
      sqliteReady: sqliteReady,
      readyDatabases: readyDatabases,
    );
  }
}
