import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view_model/media_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/state/media_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_list_state_view.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/media_thumbnail.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'media_detail.dart';

class MediaListPage extends ConsumerStatefulWidget {
  const MediaListPage({super.key});

  @override
  ConsumerState<MediaListPage> createState() => _MediaListPageState();
}

class _MediaListPageState extends ConsumerState<MediaListPage> {
  MediaList get _notifier => ref.read(mediaListProvider.notifier);

  Future<void> _downloadServerMedia(MediaFileInfo mediaFile) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showPromptDialog(
      context,
      title: l10n.mediaDownloadConfirmTitle,
      message: l10n.mediaDownloadConfirmMessage(mediaFile.name),
      confirmText: l10n.mediaDownloadButton,
      cancelText: l10n.mediaCancel,
    );

    if (confirmed != true) return;
    if (!mounted) return;

    await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
      context: context,
      operation: () async {
        final result = await _notifier.downloadServerMedia(mediaFile);
        if (!mounted) return;
        switch (result) {
          case MediaDownloadSuccess():
            showStatusToast(
              context,
              variant: StatusVariant.success,
              title: l10n.commonSuccess,
              message: l10n.mediaDownloadSuccess,
            );

          case MediaDownloadFailure(:final message):
            showStatusToast(
              context,
              variant: StatusVariant.error,
              title: l10n.commonError,
              message: resolveAppMessage(l10n, message),
            );
        }
      },
    );
  }

  Future<void> _deleteServerMedia(MediaFileInfo mediaFile) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showPromptDialog(
      context,
      title: l10n.mediaServerDeleteTitle,
      message: l10n.mediaServerDeleteConfirm(mediaFile.name),
      confirmText: l10n.mediaDelete,
      cancelText: l10n.mediaCancel,
    );

    if (confirmed != true) return;
    if (!mounted) return;

    await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
      context: context,
      operation: () async {
        final result = await _notifier.deleteServerMedia(mediaFile);
        if (!mounted) return;
        switch (result) {
          case MediaServerDeleteSuccess(:final message):
            await showStatusToast(
              context,
              variant: StatusVariant.success,
              title: l10n.commonSuccess,
              message: '${resolveAppMessage(l10n, message)}: ${mediaFile.name}',
            );
          case MediaServerDeleteFailure(:final message):
            showStatusToast(
              context,
              variant: StatusVariant.error,
              title: l10n.commonError,
              message: resolveAppMessage(l10n, message),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(mediaListProvider);

    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.media,
      title: l10n.mediaServerListTitle,
      mainFunctionBody: listState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildListContent(listState),
            ),
    );
  }

  Widget _buildListContent(MediaListState listState) {
    final l10n = AppLocalizations.of(context)!;
    if (listState.errorMessage.isNotEmpty) {
      return ServerListErrorView(
        errorMessage: listState.errorMessage,
        onRetry: _notifier.reload,
      );
    }
    if (listState.serverMediaFiles.isEmpty) {
      return ServerListEmptyMessage(message: l10n.mediaNoServerFiles);
    }
    return RefreshIndicator(
      onRefresh: _notifier.reload,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: listState.serverMediaFiles.length,
        itemBuilder: (context, index) {
          final mediaFile = listState.serverMediaFiles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TouchFeedbackWidget(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaDetailPage(mediaFile: mediaFile),
                  ),
                );
                if (result == true) {
                  await _notifier.reload();
                }
              },
              child: _buildServerMediaItem(mediaFile, listState),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServerMediaItem(
    MediaFileInfo mediaFile,
    MediaListState listState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isDownloading =
        listState.isDownloading &&
        listState.downloadingFileName == mediaFile.name;

    return Card(
      elevation: 2,
      color: EgovColor.white100,
      child: ListTile(
        leading: SizedBox(
          width: 72,
          height: 72,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ServerMediaThumbnail(
              mediaFile: mediaFile,
              showVideoPlayOverlay: mediaFile.type == MediaType.video,
            ),
          ),
        ),

        title: Text(
          mediaFile.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_buildFileInfoText(mediaFile)),
            Text(
              l10n.mediaServerFileBadge,
              style: TextStyle(fontSize: 11, color: EgovColor.gray60),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDownloading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: listState.downloadProgress,
                ),
              )
            else
              IconButton(
                onPressed: () => _downloadServerMedia(mediaFile),
                icon: const Icon(Icons.download),
                color: EgovColor.primary50,
                iconSize: 20,
                tooltip: l10n.mediaDownloadButton,
              ),

            IconButton(
              onPressed: () => _deleteServerMedia(mediaFile),
              icon: const Icon(Icons.delete),
            color: EgovColor.danger50,
              iconSize: 20,
              tooltip: l10n.mediaDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _buildFileInfoText(MediaFileInfo mediaFile) {
    final l10n = AppLocalizations.of(context)!;
    String extension = '';
    if (mediaFile.fileExtsn != null && mediaFile.fileExtsn!.isNotEmpty) {
      extension = mediaFile.fileExtsn!.startsWith('.')
          ? mediaFile.fileExtsn!.substring(1)
          : mediaFile.fileExtsn!;
    } else if (mediaFile.name.isNotEmpty) {
      final parts = mediaFile.name.split('.');
      if (parts.length > 1) {
        extension = parts.last;
      }
    }
    final sizeText = mediaFile.size > 0
        ? mediaFile.formattedSize
        : l10n.mediaUnknownSize;

    if (extension.isNotEmpty) {
      return '$extension · $sizeText';
    }
    return sizeText;
  }
}

class _TouchFeedbackWidget extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  const _TouchFeedbackWidget({required this.onTap, required this.child});

  @override
  State<_TouchFeedbackWidget> createState() => _TouchFeedbackWidgetState();
}

class _TouchFeedbackWidgetState extends State<_TouchFeedbackWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: EgovColor.black10,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [
                  BoxShadow(
                    color: EgovColor.black25,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),

        child: Transform.scale(
          scale: isPressed ? 0.95 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}
