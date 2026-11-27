import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';

class AiChatSession {
  final String id;
  final List<AiChatInfo> messages;

  const AiChatSession({
    required this.id,
    required this.messages,
  });

  String get sessionId =>
      messages.isEmpty ? id : messages.first.sessionId;

  String get firstQuestion =>
      messages.isEmpty ? '' : messages.first.question;

  String get lastTimestamp {
    if (messages.isEmpty) {
      return '';
    }
    final last = messages.last;
    return last.answerTimestamp.isNotEmpty
        ? last.answerTimestamp
        : last.questionTimestamp;
  }

  String get chatMode =>
      messages.isEmpty ? 'rag' : messages.last.chatMode;

  int get messageCount => messages.length;

  static String groupKey(AiChatInfo item) {
    final sessionId = item.sessionId.trim();
    if (sessionId.isNotEmpty) {
      return sessionId;
    }
    return 'sn:${item.sn}';
  }

  static List<AiChatSession> fromMessages(List<AiChatInfo> items) {
    final grouped = <String, List<AiChatInfo>>{};
    for (final item in items) {
      grouped.putIfAbsent(groupKey(item), () => []).add(item);
    }

    final sessions = grouped.entries.map((entry) {
      final messages = [...entry.value]
        ..sort((a, b) {
          final byTime = a.questionTimestamp.compareTo(b.questionTimestamp);
          if (byTime != 0) {
            return byTime;
          }
          return a.sn.compareTo(b.sn);
        });
      return AiChatSession(id: entry.key, messages: messages);
    }).toList()
      ..sort((a, b) => b.lastTimestamp.compareTo(a.lastTimestamp));

    return sessions;
  }
}
