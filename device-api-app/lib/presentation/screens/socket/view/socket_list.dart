import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/state/socket_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view_model/socket_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/widgets/socket_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocketListPage extends ConsumerStatefulWidget {
  const SocketListPage({super.key});

  @override
  ConsumerState<SocketListPage> createState() => _SocketListPageState();
}

class _SocketListPageState extends ConsumerState<SocketListPage> {
  Future<void> _deleteAll() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.socketDeleteAllTitle,
      message: l10n.socketDeleteAllConfirm,
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(socketListProvider.notifier);
    final result = await notifier.deleteAll();

    if (!mounted) return;

    switch (result) {
      case SocketDeleteAllSuccess():
        ref.read(socketMainProvider.notifier).clearSavedSn();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.socketDeleteAllSuccess,
        );
        await notifier.reload();
        if (mounted) Navigator.pop(context);
      case SocketDeleteAllFailure(:final message):
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
    final listState = ref.watch(socketListProvider);
    final notifier = ref.read(socketListProvider.notifier);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.socket,
      title: l10n.socketApiTitle,
      mainFunctionBody: listState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildListContent(l10n, listState, notifier),
            ),
    );
  }

  Widget _buildListContent(
    AppLocalizations l10n,
    SocketListState listState,
    SocketList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.messageList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.socketEmptyList);
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.builder(
        itemCount: listState.messageList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: ServerConnectionButton(
                  text: l10n.socketDeleteAllButton,
                  normalColor: EgovColor.point50,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                  onServerConnected: _deleteAll,
                ),
              ),
            );
          }

          final item = listState.messageList[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SocketCard(
              title: item.message.length > 40
                  ? '${item.message.substring(0, 40)}...'
                  : item.message,
              subtitle: '${l10n.socketListItemSender} : ${item.sender}',
              detailLabel: l10n.socketTimestampLabel,
              detailValue: item.timestamp,
            ),
          );
        },
      ),
    );
  }
}
