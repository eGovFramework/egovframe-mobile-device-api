/// 스트리밍 중에도 {@code </think>} 앞의 추론은 화면에 남기지 않는다.
class AiChatThinkStripper {
  static String visible(String raw) {
    if (raw.isEmpty) {
      return raw;
    }

    var text = _removeCompleteBlocks(raw);
    final orphan = _splitOrphanClose(text);
    if (orphan != null) {
      text = orphan;
    }
    text = _dropUnclosedOpen(text);
    return text;
  }

  static String _removeCompleteBlocks(String text) {
    return text.replaceAll(
      RegExp(r'<thinking>[\s\S]*?</thinking>|<think>[\s\S]*?</think>', caseSensitive: false),
      '',
    );
  }

  static String? _splitOrphanClose(String text) {
    final lower = text.toLowerCase();
    final thinkingEnd = lower.indexOf('</thinking>');
    final thinkEnd = lower.indexOf('</think>');
    if (thinkingEnd < 0 && thinkEnd < 0) {
      return null;
    }
    if (thinkingEnd >= 0 && (thinkEnd < 0 || thinkingEnd <= thinkEnd)) {
      return text.substring(thinkingEnd + '</thinking>'.length);
    }
    return text.substring(thinkEnd + '</think>'.length);
  }

  static String _dropUnclosedOpen(String text) {
    final lower = text.toLowerCase();
    final thinkingAt = lower.indexOf('<thinking>');
    final thinkAt = lower.indexOf('<think>');
    if (thinkingAt < 0 && thinkAt < 0) {
      return text;
    }
    if (thinkingAt >= 0 && (thinkAt < 0 || thinkingAt <= thinkAt)) {
      return text.substring(0, thinkingAt);
    }
    return text.substring(0, thinkAt);
  }
}
