import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/state/socket_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view/socket_chat.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view/socket_list.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view_model/socket_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view_model/socket_connection_status_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/widgets/socket_chat_overview.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/widgets/socket_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/widgets/socket_connection_resolver.dart';

import 'socket_description.dart';

class SocketPage extends ConsumerStatefulWidget {
  const SocketPage({super.key});

  @override
  ConsumerState<SocketPage> createState() => _SocketPageState();
}

class _SocketPageState extends ConsumerState<SocketPage> {
  SocketMain get _notifier => ref.read(socketMainProvider.notifier);
  final TextEditingController _nicknameController = TextEditingController();
  bool _nicknameInitialized = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _handleLoadError(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'SocketPage.loadError',
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
      onRetry: () => _connectAndOpenChat(),
      retryText: l10n.commonRetry,
    );
  }

  Future<void> _navigateToChat() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SocketChatPage()),
    );
  }

  Future<void> _connectAndOpenChat() async {
    await _notifier.connectWebSocket();
    if (!mounted) return;

    final mainState = ref.read(socketMainProvider);
    if (mainState.loadError != null) {
      return;
    }

    await _navigateToChat();
  }

  Future<void> _disconnect() async {
    await _notifier.disconnectWebSocket();
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

  Future<void> _navigateToList() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SocketListPage()),
    );
  }

  Widget _buildMainFunctionBody(SocketMainState mainState) {
    if (mainState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_nicknameInitialized && mainState.senderName.isNotEmpty) {
      _nicknameController.text = mainState.senderName;
      _nicknameInitialized = true;
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(socketConnectionStatusProvider.notifier).refresh();
      },
      color: EgovColor.primary50,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: SocketChatOverview(
          mainState: mainState,
          nicknameController: _nicknameController,
          onSenderNameChanged: _notifier.updateSenderName,
          onConnect: _connectAndOpenChat,
          onDisconnect: _disconnect,
          onOpenChat: _navigateToChat,
          footer: const SocketConnectionBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainState = ref.watch(socketMainProvider);

    ref.listen<SocketMainState>(socketMainProvider, (previous, next) {
      final error = next.loadError;
      if (error != null && error != previous?.loadError) {
        Future.microtask(() async {
          if (!mounted) return;
          await _handleLoadError(error);
        });
      }
    });

    return FeatureShell(
      currentAppTargetPage: 'socket',
      title: l10n.socketApiTitle,
      guidePage: const SocketFunctionPage(),
      mainFunctionBody: _buildMainFunctionBody(mainState),
      bottomBar: BottomButtonRow(
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
