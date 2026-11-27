import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/state/iot_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view_model/iot_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/widgets/iot_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/widgets/iot_saved_log_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 서버/SQLite에 저장된 IoT 로그 목록
class IotSavedListPage extends ConsumerStatefulWidget {
  const IotSavedListPage({super.key});

  @override
  ConsumerState<IotSavedListPage> createState() => _IotSavedListPageState();
}

class _IotSavedListPageState extends ConsumerState<IotSavedListPage> {
  Future<void> _deleteAll() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showServerDeleteConfirm(
      context,
      title: l10n.iotDeleteAllTitle,
      message: l10n.iotDeleteAllConfirm,
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(iotSavedListProvider.notifier);
    final result = await notifier.deleteAll();
    if (!mounted) return;

    switch (result) {
      case IotDeleteAllSuccess():
        ref.read(iotMainProvider.notifier).clearSavedSn();
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.iotDeleteAllSuccess,
        );
        await notifier.reload();
      case IotDeleteAllFailure(:final message):
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
    final listState = ref.watch(iotSavedListProvider);
    final notifier = ref.read(iotSavedListProvider.notifier);

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.iot,
      title: l10n.iotApiTitle,
      mainFunctionBody: listState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildListContent(l10n, listState, notifier),
            ),
      bottomBar: BottomButtonRow(
        buttons: [
          ServerConnectionButton(
            text: l10n.iotDeleteAllButton,
            normalColor: EgovColor.point50,
            onServerConnected: _deleteAll,
            resolveConnection: IotConnectionResolver.resolveConnection,
            icon: const Icon(
              Icons.delete_outline,
              color: EgovColor.white100,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListContent(
    AppLocalizations l10n,
    IotSavedListState listState,
    IotSavedList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.messageList.isEmpty) {
      return ServerListEmptyMessage(message: l10n.iotSavedEmptyList);
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.separated(
        itemCount: listState.messageList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return IotSavedLogCard(info: listState.messageList[index]);
        },
      ),
    );
  }
}
