import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';

abstract class AiChatRepository {
  Future<AiChatInfo?> askAiChat(
    AiChatInfo info, {
    void Function(String token)? onToken,
  });

  Future<bool> uploadAiChatInfo(AiChatInfo info);

  Future<List<AiChatInfo>> getAiChatList();

  /// AI(LLM) 서버 연결. 웹 서버에 확인 요청이 닿지 않으면 null.
  Future<bool?> checkAiServerConnection();

  Future<bool> deleteAiChatInfo(AiChatInfo info, String deviceUuid);
}
