enum IotMessageDirection { incoming, outgoing }

enum IotMessageType { telemetry, command }

/// MQTT 송수신 로그 (화면·저장용)
class IotMessageLog {
  final String topic;
  final String payload;
  final DateTime at;
  final IotMessageDirection direction;
  final IotMessageType messageType;
  final int? savedSn;

  const IotMessageLog({
    required this.topic,
    required this.payload,
    required this.at,
    required this.direction,
    required this.messageType,
    this.savedSn,
  });

  bool get isSynced => savedSn != null;

  String get directionValue =>
      direction == IotMessageDirection.incoming ? 'incoming' : 'outgoing';

  String get messageTypeValue =>
      messageType == IotMessageType.telemetry ? 'telemetry' : 'command';

  IotMessageLog copyWith({int? savedSn}) {
    return IotMessageLog(
      topic: topic,
      payload: payload,
      at: at,
      direction: direction,
      messageType: messageType,
      savedSn: savedSn ?? this.savedSn,
    );
  }

  static IotMessageType resolveMessageType(String topic) {
    final lower = topic.toLowerCase();
    if (lower.endsWith('/command') || lower.contains('/command/')) {
      return IotMessageType.command;
    }
    return IotMessageType.telemetry;
  }
}
