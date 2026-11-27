import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class PushMessageInfo {
  final int sn;
  final String uuid;
  final String message;
  final String sndDt;
  final String tokenId;

  const PushMessageInfo({
    required this.sn,
    required this.uuid,
    required this.message,
    required this.sndDt,
    required this.tokenId,
  });

  factory PushMessageInfo.fromJson(Map<String, dynamic> json) {
    return PushMessageInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      message: JsonRead.asString(json, ['message', 'MESSAGE']),
      sndDt: JsonRead.asString(json, ['sndDt', 'SND_DT']),
      tokenId: JsonRead.asString(json, ['tokenId', 'TOKEN_ID']),
    );
  }
}
