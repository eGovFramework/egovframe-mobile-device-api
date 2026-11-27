import 'package:egovframe_mobile_deviceapi_app/data/aiChat/repositories/ai_chat_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/aiChat/repositories/ai_chat_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/repositories/ai_chat_repository.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteRepositoryImpl _remote;
  final AiChatSqliteRepositoryImpl _sqlite;
  final AiChatConnectionReader _readConnection;

  AiChatRepositoryImpl({
    required AiChatRemoteRepositoryImpl remote,
    required AiChatSqliteRepositoryImpl sqlite,
    required AiChatConnectionReader readConnection,
  }) : _remote = remote,
       _sqlite = sqlite,
       _readConnection = readConnection;

  AiChatRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<AiChatInfo?> askAiChat(
    AiChatInfo info, {
    void Function(String token)? onToken,
  }) => _remote.askAiChat(info, onToken: onToken);

  @override
  Future<bool> uploadAiChatInfo(AiChatInfo info) =>
      _active.uploadAiChatInfo(info);

  @override
  Future<List<AiChatInfo>> getAiChatList() => _active.getAiChatList();

  @override
  Future<bool?> checkAiServerConnection() => _remote.checkAiServerConnection();

  @override
  Future<bool> deleteAiChatInfo(AiChatInfo info, String deviceUuid) =>
      _active.deleteAiChatInfo(info, deviceUuid);
}
