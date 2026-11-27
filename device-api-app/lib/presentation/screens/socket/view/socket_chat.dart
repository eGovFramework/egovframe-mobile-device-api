import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/state/socket_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view/socket_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view_model/socket_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/widgets/socket_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/websocket_connection_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

const _chatMessageMaxLength = 500;

class SocketChatPage extends ConsumerStatefulWidget {
  const SocketChatPage({super.key});

  @override
  ConsumerState<SocketChatPage> createState() => _SocketChatPageState();
}

class _SocketChatPageState extends ConsumerState<SocketChatPage> {
  final TextEditingController _inputController = TextEditingController();

  SocketMain get _notifier => ref.read(socketMainProvider.notifier);

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _handleLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'SocketChatPage.loadError',
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
    );
  }

  String _connectionStatusText(AppLocalizations l10n, SocketMainState state) {
    final connectionState = state.connectionState;
    if (connectionState is ws.Connected ||
        connectionState is ws.Reconnected) {
      return l10n.socketWebsocketConnected;
    }
    if (connectionState is ws.Connecting) {
      return l10n.socketWebsocketConnecting;
    }
    if (connectionState is ws.Reconnecting) {
      return l10n.socketWebsocketReconnecting;
    }
    return l10n.socketWebsocketDisconnected;
  }

  void _sendMessage() {
    _notifier.sendMessage();
    _inputController.clear();
  }

  Future<void> _navigateToList() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SocketListPage()),
    );
  }

  Future<void> _uploadSocketMessage() async {
    final l10n = AppLocalizations.of(context)!;
    final unsyncedCount = _notifier.unsyncedMessageCount;

    if (!ref.read(socketMainProvider).hasMessages) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.socketNoMessageData,
      );
      return;
    }

    if (unsyncedCount == 0) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.socketNoNewMessages,
      );
      return;
    }

    final confirmed = await showServerRegisterConfirm(
      context,
      title: l10n.socketSaveTitle,
      message: l10n.socketSaveConfirm(unsyncedCount),
    );
    if (!confirmed || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(l10n.socketUploading),
            ],
          ),
        );
      },
    );

    final result = await _notifier.uploadSocketMessages();

    if (!mounted) return;
    Navigator.of(context).pop();

    switch (result) {
      case SocketUploadSuccess(:final syncedCount):
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.socketSaveSuccess(syncedCount),
        );
      case SocketUploadFailure(:final message):
        final localizedMessage = resolveAppMessage(l10n, message);
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: localizedMessage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(socketMainProvider);
    final canSend = isWebSocketConnected(mainState.connectionState);
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    ref.listen<SocketMainState>(socketMainProvider, (previous, next) {
      final error = next.loadError;
      if (error != null && error != previous?.loadError) {
        Future.microtask(() async {
          if (!mounted) return;
          await _handleLoadError(error);
        });
      }
    });

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.socket,
      title: l10n.socketApiTitle,
      mainFunctionBody: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoBox(text: _connectionStatusText(l10n, mainState)),
            const SizedBox(height: 16),
            Text(
              l10n.socketChatMessagesTitle,
              style: EgovText.medium.copyWith(
                color: EgovColor.gray90,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: EgovColor.gray5,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: EgovColor.gray20),
                ),
                child: _ChatMessageList(
                  messages: mainState.messages,
                  emptyText: l10n.socketChatEmpty,
                  l10n: l10n,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inputController,
              onChanged: _notifier.updateInputText,
              enabled: canSend,
              maxLength: _chatMessageMaxLength,
              decoration: InputDecoration(
                hintText: l10n.socketChatInputHint,
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
              onSubmitted: canSend ? (_) => _sendMessage() : null,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: l10n.socketChatSendButton,
              onTap: canSend ? _sendMessage : null,
              icon: const Icon(
                Icons.send,
                color: EgovColor.white100,
                size: 20,
              ),
            ),
          ],
        ),
      ),
      bottomBar: isKeyboardVisible
          ? null
          : BottomButtonRow(
              buttons: [
                ServerConnectionButtonFactory.listButton(
                  text: l10n.socketListButton,
                  onServerConnected: _navigateToList,
                  resolveConnection: SocketConnectionResolver.resolveConnection,
                ),
                ServerConnectionButtonFactory.uploadButton(
                  text: l10n.socketSaveButton,
                  onServerConnected: _uploadSocketMessage,
                  resolveConnection: SocketConnectionResolver.resolveConnection,
                ),
              ],
            ),
    );
  }
}

class _ChatMessageList extends StatefulWidget {
  final List<SocketChatMessage> messages;
  final String emptyText;
  final AppLocalizations l10n;

  const _ChatMessageList({
    required this.messages,
    required this.emptyText,
    required this.l10n,
  });

  @override
  State<_ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<_ChatMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.messages.isNotEmpty) {
      _scrollToBottom();
    }
  }

  @override
  void didUpdateWidget(covariant _ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      final target = _scrollController.position.maxScrollExtent;
      if (target <= 0) {
        return;
      }

      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return Center(
        child: Text(
          widget.emptyText,
          style: EgovText.regular.copyWith(color: EgovColor.gray60),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final item = widget.messages[index];
        return _ChatBubble(message: item, l10n: widget.l10n);
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final SocketChatMessage message;
  final AppLocalizations l10n;

  const _ChatBubble({required this.message, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isMine ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor =
        message.isMine ? EgovColor.primary10 : EgovColor.white100;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: EgovColor.gray20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: EgovText.regular.copyWith(color: EgovColor.gray90),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.socketListItemSender} : ${message.sender} · ${KstDateTimeUtil.format(message.receivedAt)}',
              style: EgovText.caption.copyWith(
                color: EgovColor.gray60,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
