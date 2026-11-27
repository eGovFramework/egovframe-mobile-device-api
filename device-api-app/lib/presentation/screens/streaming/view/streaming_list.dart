import 'package:egovframe_mobile_deviceapi_app/domain/streaming/entities/streaming_media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/di/streaming_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/streaming_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/state/streaming_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/view/streaming_video_player_page.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/view_model/streaming_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/widgets/streaming_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamingListPage extends ConsumerStatefulWidget {
  const StreamingListPage({super.key});

  @override
  ConsumerState<StreamingListPage> createState() => _StreamingListPageState();
}

class _StreamingListPageState extends ConsumerState<StreamingListPage> {
  Future<void> _playMedia(StreamingMediaInfo item) async {
    final l10n = AppLocalizations.of(context)!;
    final connection = ref.read(streamingConnectionProvider);

    if (connection.isSqlite) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.streamingRequiresServer,
      );
      return;
    }

    if (!item.hasPlayableFile) {
      await showStatusToast(
        context,
        variant: StatusVariant.error,
        title: l10n.commonError,
        message: l10n.streamingVideoFileNotFound,
      );
      return;
    }

    final confirmed = await showPromptDialog(
      context,
      title: l10n.streamingPlayConfirmTitle,
      message: l10n.streamingPlayConfirmMessage,
      confirmText: l10n.commonConfirm,
      cancelText: l10n.commonCancel,
    );
    if (confirmed != true || !mounted) return;

    final notifier = ref.read(streamingListProvider.notifier);
    final streamUrl = await notifier.buildStreamingUrl(item);

    await notifier.incrementPlayCount(item.sn);

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamingVideoPlayerPage(
          title: item.mdSj,
          videoUrl: streamUrl,
        ),
      ),
    );

    if (mounted) {
      await notifier.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(streamingListProvider);
    final notifier = ref.read(streamingListProvider.notifier);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.streaming,
      title: l10n.streamingApiTitle,
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
    StreamingListState listState,
    StreamingList notifier,
  ) {
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: resolveAppMessage(l10n, listState.errorMessage),
        onRetry: notifier.reload,
      );
    }

    if (listState.mediaList.isEmpty) {
      return ServerListEmptyMessage(
        message: resolveAppMessage(l10n, StreamingMessageKeys.emptyList),
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: EgovColor.primary50,
      child: ListView.builder(
        itemCount: listState.mediaList.length,
        itemBuilder: (context, index) {
          final item = listState.mediaList[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _playMedia(item),
                child: StreamingCard(
                  title: item.mdSj,
                  subtitle:
                      '${l10n.streamingFileTypeLabel} : ${item.mdCode.isNotEmpty ? item.mdCode : '-'}',
                  detailLabel: l10n.streamingPlayCountLabel,
                  detailValue: item.revivCo,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
