import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/aiChat/entities/ai_chat_session.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/state/ai_chat_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view/ai_chat_detail.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view_model/ai_chat_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_ai_server_banner.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/widgets/ai_chat_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiChatListPage extends ConsumerStatefulWidget {
  const AiChatListPage({super.key});

  @override
  ConsumerState<AiChatListPage> createState() => _AiChatListPageState();
}

class _AiChatListPageState extends ConsumerState<AiChatListPage> {
  final Set<String> _selectedSessionIds = {};

  void _clearSelection() {
    setState(_selectedSessionIds.clear);
  }

  void _toggleSelection(AiChatSession session) {
    setState(() {
      if (_selectedSessionIds.contains(session.id)) {
        _selectedSessionIds.remove(session.id);
      } else {
        _selectedSessionIds.add(session.id);
      }
    });
  }

  List<AiChatSession> _selectedSessions(AiChatListState listState) {
    return listState.sessions
        .where((session) => _selectedSessionIds.contains(session.id))
        .toList();
  }

  Future<void> _openDetail(AiChatSession session) async {
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AiChatDetailPage(session: session),
      ),
    );
    if (!mounted) return;
    if (deleted == true) {
      _clearSelection();
      await ref.read(aiChatListProvider.notifier).reload();
    }
  }

  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.read(aiChatListProvider);
    final selectedSessions = _selectedSessions(listState);
    final selectedItems = selectedSessions
        .expand((session) => session.messages)
        .toList();

    if (selectedItems.isEmpty) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.aiChatNoSelection,
      );
      return;
    }

    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.aiChatDeleteSelectedTitle,
      message: l10n.aiChatDeleteSelectedConfirm(selectedSessions.length),
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(aiChatListProvider.notifier);
    final result = await notifier.deleteSelectedItems(selectedItems);

    if (!mounted) return;

    switch (result) {
      case AiChatDeleteBatchSuccess():
        _clearSelection();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.aiChatDeleteSelectedSuccess,
        );
        await notifier.reload();
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
    final listState = ref.watch(aiChatListProvider);
    final notifier = ref.read(aiChatListProvider.notifier);
    final hasSelection = _selectedSessionIds.isNotEmpty;

    return PopScope(
      canPop: !hasSelection,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _clearSelection();
      },
      child: ApiFeatureShell(
        popToApiMainCount: 1,
        feature: ApiFeature.aiChat,
        title: hasSelection
            ? l10n.aiChatSelectedCount(_selectedSessionIds.length)
            : l10n.aiChatApiTitle,
        mainFunctionBody: listState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (listState.aiServerConnected == false) ...[
                      const AiChatAiServerBanner(),
                      const SizedBox(height: 12),
                    ],
                    Expanded(
                      child: _buildListContent(
                        l10n,
                        listState,
                        notifier,
                        hasSelection,
                      ),
                    ),
                  ],
                ),
              ),
        bottomBar: hasSelection
            ? BottomButtonRow(
                buttons: [
                  CustomButton(
                    text: l10n.commonCancel,
                    onTap: _clearSelection,
                    normalColor: EgovColor.gray70,
                    icon: const Icon(
                      Icons.close,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                  ),
                  ServerConnectionButton(
                    text: l10n.aiChatDeleteSelectedButton,
                    normalColor: EgovColor.point50,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: EgovColor.white100,
                      size: 20,
                    ),
                    onServerConnected: _deleteSelected,
                    resolveConnection: AiChatConnectionResolver.resolveConnection,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildListContent(
    AppLocalizations l10n,
    AiChatListState listState,
    AiChatList notifier,
    bool hasSelection,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.sessions.isEmpty) {
      return ServerListEmptyMessage(message: l10n.aiChatEmptyList);
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listState.sessions.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InfoBox(
                text: hasSelection
                    ? l10n.aiChatSelectedCount(_selectedSessionIds.length)
                    : l10n.aiChatSelectionModeHint,
              ),
            );
          }

          final session = listState.sessions[index - 1];
          final isSelected = _selectedSessionIds.contains(session.id);

          return _SelectableAiChatSessionTile(
            session: session,
            isSelected: isSelected,
            modeLabel: session.chatMode == 'simple'
                ? l10n.aiChatModeSimple
                : l10n.aiChatModeRag,
            messageCountLabel: l10n.aiChatSessionMessageCount(
              session.messageCount,
            ),
            timestampLabel: l10n.aiChatTimestampLabel,
            onToggleSelect: () => _toggleSelection(session),
            onOpen: hasSelection
                ? () => _toggleSelection(session)
                : () => _openDetail(session),
          );
        },
      ),
    );
  }
}

class _SelectableAiChatSessionTile extends StatelessWidget {
  final AiChatSession session;
  final bool isSelected;
  final String modeLabel;
  final String messageCountLabel;
  final String timestampLabel;
  final VoidCallback onToggleSelect;
  final VoidCallback onOpen;

  const _SelectableAiChatSessionTile({
    required this.session,
    required this.isSelected,
    required this.modeLabel,
    required this.messageCountLabel,
    required this.timestampLabel,
    required this.onToggleSelect,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final questionText = session.firstQuestion.length > 60
        ? '${session.firstQuestion.substring(0, 60)}...'
        : session.firstQuestion;

    return Material(
      color: isSelected ? EgovColor.primary5 : EgovColor.white100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onOpen,
        onLongPress: onToggleSelect,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? EgovColor.primary30 : EgovColor.gray20,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isSelected ? EgovColor.primary50 : EgovColor.gray50,
                  ),
                  onPressed: onToggleSelect,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionText,
                      style: EgovText.medium.copyWith(
                        color: EgovColor.gray90,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$messageCountLabel · $modeLabel',
                      style: EgovText.caption.copyWith(color: EgovColor.gray70),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$timestampLabel : ${session.lastTimestamp}',
                      style: EgovText.caption.copyWith(color: EgovColor.gray70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: EgovColor.gray50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
