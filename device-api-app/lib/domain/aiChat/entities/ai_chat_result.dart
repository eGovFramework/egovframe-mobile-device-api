import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/ai_chat_message_keys.dart';

sealed class AiChatAskResult {
  const AiChatAskResult();
}

class AiChatAskSuccess extends AiChatAskResult {
  final AiChatInfo info;

  const AiChatAskSuccess(this.info);
}

class AiChatAskFailure extends AiChatAskResult {
  final String message;

  const AiChatAskFailure(this.message);
}

sealed class AiChatListLoadResult {
  const AiChatListLoadResult();
}

class AiChatListLoadSuccess extends AiChatListLoadResult {
  final List<AiChatInfo> items;

  const AiChatListLoadSuccess(this.items);
}

class AiChatListLoadEmpty extends AiChatListLoadResult {
  final String message;

  const AiChatListLoadEmpty([this.message = AiChatMessageKeys.emptyList]);
}

class AiChatListLoadFailure extends AiChatListLoadResult {
  final String message;

  const AiChatListLoadFailure(this.message);
}

sealed class AiChatDeleteBatchResult {
  const AiChatDeleteBatchResult();
}

class AiChatDeleteBatchSuccess extends AiChatDeleteBatchResult {
  final int deletedCount;

  const AiChatDeleteBatchSuccess(this.deletedCount);
}

class AiChatDeleteBatchFailure extends AiChatDeleteBatchResult {
  final String message;

  const AiChatDeleteBatchFailure(this.message);
}
