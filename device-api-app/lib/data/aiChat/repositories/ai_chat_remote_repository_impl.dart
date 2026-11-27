import 'package:egovframe_mobile_deviceapi_app/data/aiChat/datasources/ai_chat_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/repositories/ai_chat_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';

class AiChatRemoteRepositoryImpl implements AiChatRepository {
  @override
  Future<AiChatInfo?> askAiChat(
    AiChatInfo info, {
    void Function(String token)? onToken,
  }) async {
    final response = await AiChatService.askAiChat(
      info.toAskFields(),
      onToken: onToken,
    );
    if (response == null) {
      return null;
    }

    final resultState = (response['resultState'] ?? '').toString();
    if (resultState != 'OK') {
      throw Exception((response['resultMessage'] ?? 'ask fail').toString());
    }

    final raw = response['aiChatInfo'];
    if (raw is Map) {
      return AiChatInfo.fromJson(Map<String, dynamic>.from(raw))
          .withFallbackTimestamps(
            questionTimestamp: info.questionTimestamp,
            answerTimestamp: KstDateTimeUtil.formatNow(),
          );
    }
    return info;
  }

  @override
  Future<bool> uploadAiChatInfo(AiChatInfo info) async {
    final response = await AiChatService.postAiChatInfo(info.toUploadFields());
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }

  @override
  Future<bool?> checkAiServerConnection() => AiChatService.fetchAiRagConnection();

  @override
  Future<List<AiChatInfo>> getAiChatList() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    final rawList = await AiChatService.fetchAiChatInfoList(uuid);
    return rawList.map(AiChatInfo.fromJson).toList();
  }

  @override
  Future<bool> deleteAiChatInfo(AiChatInfo info, String deviceUuid) async {
    if (deviceUuid.isEmpty || info.uuid != deviceUuid || info.sn <= 0) {
      return false;
    }

    final response = await AiChatService.deleteAiChatInfo(
      sn: info.sn,
      uuid: deviceUuid,
    );
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}
