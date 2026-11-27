import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/state/ai_chat_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view_model/ai_chat_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view/ai_chat_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view_model/ai_chat_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ai_chat_description.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final TextEditingController _questionController = TextEditingController();

  AiChatMain get _notifier => ref.read(aiChatMainProvider.notifier);

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _handleLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'AiChatPage.loadError',
    );

    final errorType = ErrorHandler.detectErrorType(localizedMessage);
    final errorMessage = ErrorHandler.getErrorMessage(
      localizedMessage,
      errorType,
    );

    await ErrorHandler.showErrorDialog(
      context,
      errorMessage,
      title: l10n.commonError,
      retryText: l10n.commonRetry,
    );
  }

  Future<void> _askQuestion() async {
    final l10n = AppLocalizations.of(context)!;
    _notifier.updateQuestionDraft(_questionController.text);

    if (_notifier.buildAskInfo() == null) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.aiChatNoQuestion,
      );
      return;
    }

    _notifier.startPendingAsk();
    _questionController.clear();

    final connected = await AiChatConnectionResolver.resolveAskConnection(
      context: context,
      ref: ref,
    );
    if (!connected || !mounted) {
      _notifier.cancelPendingAsk();
      _questionController.text = ref.read(aiChatMainProvider).questionDraft;
      return;
    }

    final result = await _notifier.askCurrentQuestion();
    if (!mounted) return;

    switch (result) {
      case AiChatAskSuccess():
        return;
      case AiChatAskFailure(:final message):
        _questionController.text = ref.read(aiChatMainProvider).questionDraft;
        final localizedMessage = resolveAppMessage(l10n, message);
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: localizedMessage,
        );
    }
  }

  Future<void> _openList() async {
    final connected = await AiChatConnectionResolver.resolveConnection(
      context: context,
      ref: ref,
    );
    if (!connected || !mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AiChatListPage()),
    );
    if (!mounted) return;
    await ref.read(aiChatConnectionStatusProvider.notifier).refresh();
  }

  Widget _buildMainFunctionBody(AiChatMainState mainState) {
    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return AiChatOverview(
      aiServerConnected: mainState.aiServerConnected,
      messages: mainState.messages,
      pendingQuestion: mainState.pendingQuestion,
      pendingQuestionTimestamp: mainState.pendingQuestionTimestamp,
      pendingAnswer: mainState.pendingAnswer,
      questionController: _questionController,
      chatMode: mainState.chatMode,
      isAsking: mainState.isAsking,
      onQuestionChanged: _notifier.updateQuestionDraft,
      onChatModeChanged: _notifier.updateChatMode,
      onSend: _askQuestion,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(aiChatMainProvider);

    ref.listen<AiChatMainState>(aiChatMainProvider, (previous, next) {
      final error = next.loadError;
      if (error != null && error != previous?.loadError) {
        Future.microtask(() async {
          if (!mounted) return;
          await _handleLoadError(error);
        });
      }
    });

    return FeatureShell(
      currentAppTargetPage: 'aiChat',
      title: l10n.aiChatApiTitle,
      guidePage: const AiChatFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState),
      appBarBuilder: (controller) => CustomAppBar(
        title: l10n.aiChatApiTitle,
        hideHomeButton: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
          onPressed: controller.handleBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: EgovColor.white100),
            tooltip: l10n.aiChatListTooltip,
            onPressed: _openList,
          ),
        ],
      ),
    );
  }
}
