import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_session.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/usecases/ai_chat_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/ai_chat_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/state/ai_chat_state.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_chat_controller.g.dart';

AiChatUseCase _aiChatUseCase(Ref ref) => ref.read(aiChatUseCaseProvider);

@riverpod
class AiChatMain extends _$AiChatMain {
  @override
  AiChatMainState build() {
    Future.microtask(initialize);
    return AiChatMainState.initial();
  }

  Future<void> initialize() async {
    final uuidFuture = _aiChatUseCase(ref).getDeviceUuid();
    final aiServerFuture = _aiChatUseCase(ref).checkAiServerConnection();
    final uuid = await uuidFuture;
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: false, uuid: uuid);

    final aiServerConnected = await aiServerFuture;
    if (!ref.mounted) return;
    state = state.copyWith(
      aiServerConnected: aiServerConnected,
      updateAiServerConnection: true,
    );
  }

  void updateQuestionDraft(String value) {
    state = state.copyWith(questionDraft: value);
  }

  void updateChatMode(String mode) {
    state = state.copyWith(chatMode: mode);
  }

  AiChatInfo? buildAskInfo({
    String? questionOverride,
    String? questionTimestamp,
  }) {
    final question = (questionOverride ?? state.questionDraft).trim();
    if (question.isEmpty || state.uuid.isEmpty) {
      return null;
    }

    return AiChatInfo(
      sn: 0,
      uuid: state.uuid,
      question: question,
      answer: '',
      chatMode: state.chatMode,
      modelNm: '',
      sessionId: state.sessionId,
      useYn: 'Y',
      questionTimestamp: (questionTimestamp != null &&
              questionTimestamp.trim().isNotEmpty)
          ? questionTimestamp.trim()
          : KstDateTimeUtil.format(DateTime.now()),
    );
  }

  bool startPendingAsk() {
    if (state.isAsking) {
      return false;
    }

    final info = buildAskInfo();
    if (info == null) {
      return false;
    }

    state = state.copyWith(
      isAsking: true,
      pendingQuestion: info.question,
      pendingQuestionTimestamp: info.questionTimestamp,
      pendingAnswer: '',
      questionDraft: '',
      clearLoadError: true,
    );
    return true;
  }

  void cancelPendingAsk() {
    if (!state.isAsking) {
      return;
    }

    state = state.copyWith(
      isAsking: false,
      questionDraft: state.pendingQuestion,
      pendingQuestion: '',
      pendingQuestionTimestamp: '',
      pendingAnswer: '',
    );
  }

  Future<AiChatAskResult> askCurrentQuestion() async {
    final pending = state.pendingQuestion.trim();
    final info = pending.isNotEmpty
        ? buildAskInfo(
            questionOverride: pending,
            questionTimestamp: state.pendingQuestionTimestamp,
          )
        : buildAskInfo();
    if (info == null) {
      return const AiChatAskFailure(AiChatMessageKeys.noQuestion);
    }

    if (!state.isAsking) {
      state = state.copyWith(
        isAsking: true,
        pendingQuestion: info.question,
        pendingQuestionTimestamp: info.questionTimestamp,
        pendingAnswer: '',
        questionDraft: '',
        clearLoadError: true,
      );
    }

    final result = await _aiChatUseCase(ref).askQuestion(
      info,
      onToken: (token) {
        state = state.copyWith(pendingAnswer: '${state.pendingAnswer}$token');
      },
    );
    switch (result) {
      case AiChatAskSuccess(:final info):
        state = state.copyWith(
          isAsking: false,
          pendingQuestion: '',
          pendingQuestionTimestamp: '',
          pendingAnswer: '',
          sessionId: info.sessionId.isNotEmpty ? info.sessionId : state.sessionId,
          messages: [...state.messages, info],
        );
      case AiChatAskFailure():
        state = state.copyWith(
          isAsking: false,
          pendingQuestion: '',
          pendingQuestionTimestamp: '',
          pendingAnswer: '',
          questionDraft: info.question,
        );
    }
    return result;
  }
}

@riverpod
class AiChatList extends _$AiChatList {
  @override
  AiChatListState build() {
    Future.microtask(reload);
    return AiChatListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final listFuture = _aiChatUseCase(ref).loadAiChatList();
    final aiServerFuture = _aiChatUseCase(ref).checkAiServerConnection();
    final result = await listFuture;
    final aiServerConnected = await aiServerFuture;

    switch (result) {
      case AiChatListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          sessions: AiChatSession.fromMessages(items),
          errorMessage: '',
          aiServerConnected: aiServerConnected,
          updateAiServerConnection: true,
        );
      case AiChatListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          sessions: [],
          errorMessage: '',
          aiServerConnected: aiServerConnected,
          updateAiServerConnection: true,
        );
      case AiChatListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          sessions: [],
          errorMessage: message,
          aiServerConnected: aiServerConnected,
          updateAiServerConnection: true,
        );
    }
  }

  Future<AiChatDeleteBatchResult> deleteSelectedItems(
    List<AiChatInfo> items,
  ) async {
    return _aiChatUseCase(ref).deleteAiChatItems(items);
  }
}
