import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class SocketMessageInfo {
  final int sn;
  final String uuid;
  final String message;
  final String sender;
  final String timestamp;
  final String useYn;

  const SocketMessageInfo({
    required this.sn,
    required this.uuid,
    required this.message,
    required this.sender,
    required this.useYn,
    required this.timestamp,
  });

  factory SocketMessageInfo.fromJson(Map<String, dynamic> json) {
    return SocketMessageInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      message: JsonRead.asString(json, ['message', 'MESSAGE']),
      sender: JsonRead.asString(json, ['sender', 'SENDER']),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      timestamp: JsonRead.asString(json, ['timestamp', 'TIMESTAMP']),
    );
  }

  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid,
      'message': message,
      'sender': sender,
      'timestamp': timestamp,
      'useYn': useYn,
    };
  }

  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      'uuid': uuid,
      'message': message,
      'sender': sender,
      'useYn': useYn,
      'timestamp': timestamp,
    };
  }
}
