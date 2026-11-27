import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_session.dart';

class AiChatMainState {
  final bool isLoading;
  final bool isAsking;
  final String? loadError;
  final String uuid;
  final String sessionId;
  final String questionDraft;
  final String pendingQuestion;
  final String pendingQuestionTimestamp;
  final String pendingAnswer;
  final String chatMode;
  final List<AiChatInfo> messages;

  /// null이면 아직 모르거나 웹 서버에 확인하지 못한 상태다.
  final bool? aiServerConnected;

  const AiChatMainState({
    required this.isLoading,
    required this.isAsking,
    this.loadError,
    required this.uuid,
    required this.sessionId,
    required this.questionDraft,
    this.pendingQuestion = '',
    this.pendingQuestionTimestamp = '',
    this.pendingAnswer = '',
    required this.chatMode,
    required this.messages,
    this.aiServerConnected,
  });

  factory AiChatMainState.initial() {
    return const AiChatMainState(
      isLoading: true,
      isAsking: false,
      uuid: '',
      sessionId: '',
      questionDraft: '',
      pendingQuestion: '',
      pendingQuestionTimestamp: '',
      pendingAnswer: '',
      chatMode: 'rag',
      messages: [],
    );
  }

  AiChatMainState copyWith({
    bool? isLoading,
    bool? isAsking,
    String? loadError,
    bool clearLoadError = false,
    String? uuid,
    String? sessionId,
    String? questionDraft,
    String? pendingQuestion,
    String? pendingQuestionTimestamp,
    String? pendingAnswer,
    String? chatMode,
    List<AiChatInfo>? messages,
    bool? aiServerConnected,
    bool updateAiServerConnection = false,
  }) {
    return AiChatMainState(
      isLoading: isLoading ?? this.isLoading,
      isAsking: isAsking ?? this.isAsking,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      uuid: uuid ?? this.uuid,
      sessionId: sessionId ?? this.sessionId,
      questionDraft: questionDraft ?? this.questionDraft,
      pendingQuestion: pendingQuestion ?? this.pendingQuestion,
      pendingQuestionTimestamp:
          pendingQuestionTimestamp ?? this.pendingQuestionTimestamp,
      pendingAnswer: pendingAnswer ?? this.pendingAnswer,
      chatMode: chatMode ?? this.chatMode,
      messages: messages ?? this.messages,
      aiServerConnected: updateAiServerConnection
          ? aiServerConnected
          : this.aiServerConnected,
    );
  }
}

class AiChatListState {
  final bool isLoading;
  final List<AiChatSession> sessions;
  final String errorMessage;

  /// null이면 아직 모르거나 웹 서버에 확인하지 못한 상태다.
  final bool? aiServerConnected;

  const AiChatListState({
    required this.isLoading,
    required this.sessions,
    required this.errorMessage,
    this.aiServerConnected,
  });

  factory AiChatListState.initial() {
    return const AiChatListState(
      isLoading: true,
      sessions: [],
      errorMessage: '',
    );
  }

  AiChatListState copyWith({
    bool? isLoading,
    List<AiChatSession>? sessions,
    String? errorMessage,
    bool? aiServerConnected,
    bool updateAiServerConnection = false,
  }) {
    return AiChatListState(
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
      errorMessage: errorMessage ?? this.errorMessage,
      aiServerConnected: updateAiServerConnection
          ? aiServerConnected
          : this.aiServerConnected,
    );
  }
}
