import 'package:egovframe_mobile_deviceapi_app/data/aiChat/datasources/ai_chat_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/repositories/ai_chat_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/ai_chat_message_keys.dart';

typedef AiChatConnectionReader = AiChatConnectionState Function();

class AiChatSqliteRepositoryImpl implements AiChatRepository {
  final AiChatSqliteService _service;
  final AiChatConnectionReader _readConnection;

  AiChatSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<AiChatInfo?> askAiChat(
    AiChatInfo info, {
    void Function(String token)? onToken,
  }) async {
    throw UnsupportedError(AiChatMessageKeys.serverRequired);
  }

  @override
  Future<bool> uploadAiChatInfo(AiChatInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.uploadAiChatInfo(dbFileName, info);
  }

  @override
  Future<bool?> checkAiServerConnection() async => null;

  @override
  Future<List<AiChatInfo>> getAiChatList() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getAiChatList(dbFileName);
  }

  @override
  Future<bool> deleteAiChatInfo(AiChatInfo info, String deviceUuid) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteAiChatInfo(dbFileName, info, deviceUuid);
  }
}
