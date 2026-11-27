import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_session.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view_model/ai_chat_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_transcript.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiChatDetailPage extends ConsumerStatefulWidget {
  final AiChatSession session;

  const AiChatDetailPage({super.key, required this.session});

  @override
  ConsumerState<AiChatDetailPage> createState() => _AiChatDetailPageState();
}

class _AiChatDetailPageState extends ConsumerState<AiChatDetailPage> {
  Future<void> _deleteSession() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.aiChatDeleteSessionTitle,
      message: l10n.aiChatDeleteSessionConfirm,
    );
    if (!confirmed || !mounted) return;

    final result = await ref
        .read(aiChatListProvider.notifier)
        .deleteSelectedItems(widget.session.messages);
    if (!mounted) return;

    switch (result) {
      case AiChatDeleteBatchSuccess():
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.aiChatDeleteSessionSuccess,
        );
        if (!mounted) return;
        Navigator.of(context).pop(true);
      case AiChatDeleteBatchFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.aiChat,
      title: l10n.aiChatDetailTitle,
      mainFunctionBody: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: EgovColor.gray5,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: EgovColor.gray20),
          ),
          child: AiChatTranscript(
            messages: widget.session.messages,
            emptyText: l10n.aiChatEmptyConversation,
          ),
        ),
      ),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButton(
            text: l10n.aiChatDeleteSessionButton,
            normalColor: EgovColor.point50,
            icon: const Icon(
              Icons.delete_outline,
              color: EgovColor.white100,
              size: 20,
            ),
            onServerConnected: _deleteSession,
            resolveConnection: AiChatConnectionResolver.resolveConnection,
          ),
        ],
      ),
    );
  }
}
