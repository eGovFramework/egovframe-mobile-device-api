import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

/// DB/서버 저장용 IoT 메시지
class IotMessageInfo {
  final int sn;
  final String uuid;
  final String topic;
  final String payload;
  final String direction;
  final String messageType;
  final String timestamp;
  final String useYn;

  const IotMessageInfo({
    required this.sn,
    required this.uuid,
    required this.topic,
    required this.payload,
    required this.direction,
    required this.messageType,
    required this.useYn,
    required this.timestamp,
  });

  factory IotMessageInfo.fromJson(Map<String, dynamic> json) {
    return IotMessageInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      topic: JsonRead.asString(json, ['topic', 'TOPIC']),
      payload: JsonRead.asString(json, ['payload', 'PAYLOAD']),
      direction: JsonRead.asString(json, ['direction', 'DIRECTION']),
      messageType: JsonRead.asString(
        json,
        ['messageType', 'MESSAGETYPE', 'message_type'],
      ),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      timestamp: JsonRead.asString(json, ['timestamp', 'TIMESTAMP']),
    );
  }

  factory IotMessageInfo.fromLog({
    required String uuid,
    required IotMessageLog log,
    required String timestamp,
  }) {
    return IotMessageInfo(
      sn: 0,
      uuid: uuid,
      topic: log.topic,
      payload: log.payload,
      direction: log.directionValue,
      messageType: log.messageTypeValue,
      useYn: 'Y',
      timestamp: timestamp,
    );
  }

  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid,
      'topic': topic,
      'payload': payload,
      'direction': direction,
      'messageType': messageType,
      'timestamp': timestamp,
      'useYn': useYn,
    };
  }
}
