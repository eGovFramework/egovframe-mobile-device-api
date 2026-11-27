import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/state/push_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/view_model/push_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/widgets/push_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushListPage extends ConsumerWidget {
  const PushListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(pushListProvider);
    final notifier = ref.read(pushListProvider.notifier);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.push,
      title: l10n.pushMessageListTitle,
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
    PushListState listState,
    PushList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.messageList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.pushEmptyMessageList);
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.builder(
        itemCount: listState.messageList.length,
        itemBuilder: (context, index) {
          final item = listState.messageList[index];
          final preview = item.message.length > 80
              ? '${item.message.substring(0, 80)}...'
              : item.message;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PushCard(
              title: preview.isNotEmpty ? preview : l10n.pushMessageListItemEmpty,
              subtitle: '${l10n.pushMessageSentAtLabel} : ${item.sndDt}',
              detailLabel: l10n.pushUuidLabel,
              detailValue: item.uuid.length > 40
                  ? '${item.uuid.substring(0, 40)}...'
                  : item.uuid,
            ),
          );
        },
      ),
    );
  }
}
