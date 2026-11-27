/// WebSocket 채팅 메시지 포맷 (`msg:발신자:내용`)
///
/// device-api-web `chat-sockjs.html`과 동일한 프로토콜을 사용합니다.
class SocketChatMessageFormat {
  SocketChatMessageFormat._();

  static const String prefix = 'msg:';

  /// 앱에서 WebSocket 송신 시 사용할 발신자 ID (기본 닉네임)
  static String resolveSenderId(String deviceUuid) {
    if (deviceUuid.isEmpty) {
      return 'app';
    }
    if (deviceUuid.length <= 16) {
      return deviceUuid;
    }
    return 'app-${deviceUuid.substring(deviceUuid.length - 8)}';
  }

  static bool isValidSenderName(String senderName) {
    final trimmed = senderName.trim();
    return trimmed.isNotEmpty && !trimmed.contains(':');
  }

  static String encode({
    required String sender,
    required String message,
  }) {
    final trimmedSender = sender.trim();
    final trimmedMessage = message.trim();
    if (trimmedSender.isEmpty || trimmedMessage.isEmpty) {
      return '';
    }
    return '$prefix$trimmedSender:$trimmedMessage';
  }

  static SocketChatMessagePayload? parse(String raw) {
    final trimmed = raw.trim();
    if (!trimmed.startsWith(prefix)) {
      return null;
    }

    final body = trimmed.substring(prefix.length);
    final separatorIndex = body.indexOf(':');
    if (separatorIndex <= 0) {
      return null;
    }

    final sender = body.substring(0, separatorIndex).trim();
    final message = body.substring(separatorIndex + 1).trim();
    if (sender.isEmpty || message.isEmpty) {
      return null;
    }

    return SocketChatMessagePayload(sender: sender, message: message);
  }
}

class SocketChatMessagePayload {
  final String sender;
  final String message;

  const SocketChatMessagePayload({
    required this.sender,
    required this.message,
  });
}
