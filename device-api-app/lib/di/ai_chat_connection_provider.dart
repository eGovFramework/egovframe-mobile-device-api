import 'package:egovframe_mobile_deviceapi_app/data/aiChat/datasources/ai_chat_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/sqlite/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_chat_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class AiChatConnection extends _$AiChatConnection {
  @override
  AiChatConnectionState build() => const AiChatConnectionState();

  void useServer() {
    state = const AiChatConnectionState(mode: AiChatConnectionMode.server);
  }

  void useSqlite(String dbFileName) {
    state = AiChatConnectionState(
      mode: AiChatConnectionMode.sqlite,
      sqliteDbFileName: dbFileName,
    );
  }
}

@Riverpod(keepAlive: true)
SqliteService sqliteService(Ref ref) => SqliteService();

@Riverpod(keepAlive: true)
FeatureTableService featureTableService(Ref ref) =>
    FeatureTableService(ref.watch(sqliteServiceProvider));

@Riverpod(keepAlive: true)
AiChatSqliteService aiChatSqliteService(Ref ref) =>
    AiChatSqliteService(ref.watch(featureTableServiceProvider));
