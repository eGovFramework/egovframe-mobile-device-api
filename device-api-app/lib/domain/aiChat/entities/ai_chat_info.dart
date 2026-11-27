import 'package:egovframe_mobile_deviceapi_app/domain/shared/json_read.dart';

class AiChatInfo {
  final int sn;
  final String uuid;
  final String question;
  final String answer;
  final String chatMode;
  final String modelNm;
  final String sessionId;
  final String useYn;
  final String questionTimestamp;
  final String answerTimestamp;

  const AiChatInfo({
    required this.sn,
    required this.uuid,
    required this.question,
    required this.answer,
    required this.chatMode,
    required this.modelNm,
    required this.sessionId,
    required this.useYn,
    required this.questionTimestamp,
    this.answerTimestamp = '',
  });

  factory AiChatInfo.fromJson(Map<String, dynamic> json) {
    return AiChatInfo(
      sn: JsonRead.asInt(json, ['sn', 'SN']),
      uuid: JsonRead.asString(json, ['uuid', 'UUID']),
      question: JsonRead.asString(json, ['question', 'QUESTION']),
      answer: JsonRead.asString(json, ['answer', 'ANSWER']),
      chatMode: JsonRead.asString(
        json,
        ['chatMode', 'CHAT_MODE'],
        defaultValue: 'rag',
      ),
      modelNm: JsonRead.asString(json, ['modelNm', 'MODEL_NM']),
      sessionId: JsonRead.asString(json, ['sessionId', 'SESSION_ID']),
      useYn: JsonRead.asString(
        json,
        ['useYn', 'useyn', 'USEYN'],
        defaultValue: 'N',
      ),
      questionTimestamp: _readTimestamp(json, const [
        'questionTimestamp',
        'QUESTION_TIMESTAMP',
        'question_timestamp',
        'QuestionTimestamp',
        'timestamp',
        'TIMESTAMP',
      ]),
      answerTimestamp: _readTimestamp(json, const [
        'answerTimestamp',
        'ANSWER_TIMESTAMP',
        'answer_timestamp',
        'AnswerTimestamp',
      ]),
    );
  }

  static String _readTimestamp(Map<String, dynamic> json, List<String> keys) {
    return _prettyTimestamp(JsonRead.asString(json, keys, trim: true));
  }

  static String _prettyTimestamp(String raw) {
    var text = raw.trim();
    if (text.endsWith('.0')) {
      text = text.substring(0, text.length - 2);
    }
    return text;
  }

  String get displayAnswerTimestamp =>
      answerTimestamp.isNotEmpty ? answerTimestamp : questionTimestamp;

  AiChatInfo withFallbackTimestamps({
    String questionTimestamp = '',
    String answerTimestamp = '',
  }) {
    return AiChatInfo(
      sn: sn,
      uuid: uuid,
      question: question,
      answer: answer,
      chatMode: chatMode,
      modelNm: modelNm,
      sessionId: sessionId,
      useYn: useYn,
      questionTimestamp: this.questionTimestamp.isNotEmpty
          ? this.questionTimestamp
          : questionTimestamp,
      answerTimestamp: this.answerTimestamp.isNotEmpty
          ? this.answerTimestamp
          : answerTimestamp,
    );
  }

  Map<String, String> toUploadFields() {
    return {
      'uuid': uuid,
      'question': question,
      'answer': answer,
      'chatMode': chatMode,
      'modelNm': modelNm,
      'sessionId': sessionId,
      'questionTimestamp': questionTimestamp,
      'answerTimestamp': answerTimestamp,
      'useYn': useYn,
    };
  }

  Map<String, String> toAskFields() {
    return {
      'uuid': uuid,
      'question': question,
      'chatMode': chatMode,
      'modelNm': modelNm,
      'sessionId': sessionId,
      'questionTimestamp': questionTimestamp,
      'useYn': useYn,
    };
  }

  Map<String, Object?> toSqliteRow() {
    return {
      'sn': sn,
      'uuid': uuid,
      'question': question,
      'answer': answer,
      'chatMode': chatMode,
      'modelNm': modelNm,
      'sessionId': sessionId,
      'useYn': useYn,
      'questionTimestamp': questionTimestamp,
      'answerTimestamp': answerTimestamp,
    };
  }
}
