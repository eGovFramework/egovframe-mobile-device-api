import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_ai_server_banner.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_connection_bar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_transcript.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class AiChatOverview extends StatelessWidget {
  final bool? aiServerConnected;
  final List<AiChatInfo> messages;
  final String pendingQuestion;
  final String pendingQuestionTimestamp;
  final String pendingAnswer;
  final TextEditingController questionController;
  final String chatMode;
  final bool isAsking;
  final ValueChanged<String> onQuestionChanged;
  final ValueChanged<String> onChatModeChanged;
  final VoidCallback onSend;

  const AiChatOverview({
    super.key,
    this.aiServerConnected,
    required this.messages,
    required this.pendingQuestion,
    this.pendingQuestionTimestamp = '',
    this.pendingAnswer = '',
    required this.questionController,
    required this.chatMode,
    required this.isAsking,
    required this.onQuestionChanged,
    required this.onChatModeChanged,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canSend = !isAsking;
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (aiServerConnected == false) ...[
            const AiChatAiServerBanner(),
            const SizedBox(height: 12),
          ],
          if (!isKeyboardVisible) ...[
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text(l10n.aiChatModeRag),
                    selected: chatMode == 'rag',
                    onSelected: isAsking
                        ? null
                        : (_) => onChatModeChanged('rag'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text(l10n.aiChatModeSimple),
                    selected: chatMode == 'simple',
                    onSelected: isAsking
                        ? null
                        : (_) => onChatModeChanged('simple'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const AiChatConnectionBar(),
            const SizedBox(height: 12),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EgovColor.gray5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.gray20),
              ),
              child: AiChatTranscript(
                messages: messages,
                pendingQuestion: pendingQuestion,
                pendingQuestionTimestamp: pendingQuestionTimestamp,
                pendingAnswer: pendingAnswer,
                isAsking: isAsking,
                emptyText: l10n.aiChatEmptyConversation,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: questionController,
            onChanged: onQuestionChanged,
            enabled: canSend,
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.aiChatQuestionHint,
              filled: true,
              fillColor: EgovColor.white100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: EgovColor.gray20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: EgovColor.gray20),
              ),
            ),
            textInputAction: TextInputAction.send,
            onSubmitted: canSend ? (_) => onSend() : null,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: l10n.aiChatSendButton,
            onTap: canSend ? onSend : null,
            icon: const Icon(
              Icons.send,
              color: EgovColor.white100,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
