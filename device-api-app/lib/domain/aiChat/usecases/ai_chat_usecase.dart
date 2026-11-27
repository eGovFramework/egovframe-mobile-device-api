import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/repositories/ai_chat_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/ai_chat_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class AiChatUseCase {
  final AiChatRepository repository;

  AiChatUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Future<AiChatAskResult> askQuestion(
    AiChatInfo info, {
    void Function(String token)? onToken,
  }) async {
    if (info.uuid.isEmpty) {
      return const AiChatAskFailure(AiChatMessageKeys.noUuid);
    }
    if (info.question.trim().isEmpty) {
      return const AiChatAskFailure(AiChatMessageKeys.noQuestion);
    }

    try {
      final saved = await repository.askAiChat(info, onToken: onToken);
      if (saved == null) {
        return const AiChatAskFailure(AiChatMessageKeys.askFailed);
      }
      return AiChatAskSuccess(saved);
    } catch (e) {
      return AiChatAskFailure('${AiChatMessageKeys.askErrorPrefix}$e');
    }
  }

  Future<AiChatAskResult> uploadAiChatToServer(AiChatInfo info) async {
    if (info.uuid.isEmpty) {
      return const AiChatAskFailure(AiChatMessageKeys.noUuid);
    }
    if (info.question.trim().isEmpty) {
      return const AiChatAskFailure(AiChatMessageKeys.noQuestion);
    }

    try {
      final success = await repository.uploadAiChatInfo(info);
      if (success) {
        return AiChatAskSuccess(info);
      }
      return const AiChatAskFailure(AiChatMessageKeys.uploadFailed);
    } catch (e) {
      return AiChatAskFailure('${AiChatMessageKeys.uploadErrorPrefix}$e');
    }
  }

  Future<bool?> checkAiServerConnection() async {
    try {
      return await repository.checkAiServerConnection();
    } catch (e) {
      return null;
    }
  }

  Future<AiChatListLoadResult> loadAiChatList() async {
    try {
      final items = await repository.getAiChatList();
      if (items.isEmpty) {
        return const AiChatListLoadEmpty();
      }
      return AiChatListLoadSuccess(items);
    } catch (e) {
      return AiChatListLoadFailure('${AiChatMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  Future<AiChatDeleteBatchResult> deleteAiChatItems(
    List<AiChatInfo> items,
  ) async {
    if (items.isEmpty) {
      return const AiChatDeleteBatchFailure(AiChatMessageKeys.noSelection);
    }

    final deviceUuid = await getDeviceUuid();
    if (deviceUuid.isEmpty) {
      return const AiChatDeleteBatchFailure(AiChatMessageKeys.noUuid);
    }

    var deletedCount = 0;
    try {
      for (final item in items) {
        if (item.uuid.isEmpty || item.uuid != deviceUuid) {
          return const AiChatDeleteBatchFailure(AiChatMessageKeys.noUuid);
        }

        final success = await repository.deleteAiChatInfo(item, deviceUuid);
        if (!success) {
          return const AiChatDeleteBatchFailure(AiChatMessageKeys.deleteFailed);
        }
        deletedCount++;
      }
      return AiChatDeleteBatchSuccess(deletedCount);
    } catch (e) {
      return AiChatDeleteBatchFailure(
        '${AiChatMessageKeys.genericErrorPrefix}$e',
      );
    }
  }
}
