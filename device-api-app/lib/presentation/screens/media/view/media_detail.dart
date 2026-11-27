import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';

import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view_model/media_controller.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/media_thumbnail.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';

import 'package:egovframe_mobile_deviceapi_app/utils/media_preview_util.dart';

import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'video_player_screen.dart';

class MediaDetailPage extends ConsumerStatefulWidget {
  final MediaFileInfo mediaFile;

  const MediaDetailPage({super.key, required this.mediaFile});

  @override
  ConsumerState<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends ConsumerState<MediaDetailPage> {
  MediaDetail get _notifier =>
      ref.read(mediaDetailProvider(widget.mediaFile).notifier);

  Future<void> _downloadMedia() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showPromptDialog(
      context,

      title: l10n.mediaDownloadConfirmTitle,
      message: l10n.mediaDownloadConfirmMessage(widget.mediaFile.name),
      confirmText: l10n.mediaDownloadButton,
      cancelText: l10n.mediaCancel,
    );

    if (confirmed != true) return;
    if (!mounted) return;

    await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
      context: context,
      operation: () async {
        final result = await _notifier.downloadMedia();
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

  void _playVideo() {
    final l10n = AppLocalizations.of(context)!;

    if (resolveServerMediaDownloadUrl(widget.mediaFile) == null) {
      showStatusToast(
        context,

        variant: StatusVariant.error,

        title: l10n.commonError,
        message: l10n.mediaNoPlayableVideo,
      );

      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: widget.mediaFile),
      ),
    );
  }

  Widget _buildPreviewSection() {
    final l10n = AppLocalizations.of(context)!;

    final isVideo = widget.mediaFile.type == MediaType.video;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            l10n.mediaPreview,

            style: TextStyle(
              fontSize: 14,

              fontWeight: FontWeight.bold,

              color: EgovColor.gray80,
            ),
          ),

          const SizedBox(height: 8),

          GestureDetector(
            onTap: isVideo ? _playVideo : null,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Container(
                width: double.infinity,

                color: EgovColor.gray10,

                child: AspectRatio(
                  aspectRatio: 16 / 9,

                  child: ServerMediaThumbnail(
                    mediaFile: widget.mediaFile,

                    fit: widget.mediaFile.type == MediaType.image
                        ? BoxFit.contain
                        : BoxFit.cover,

                    thumbnailMaxWidth: 720,

                    showVideoPlayOverlay: isVideo,
                  ),
                ),
              ),
            ),
          ),

          if (isVideo) ...[
            const SizedBox(height: 6),

            Text(
              l10n.mediaVideoPreviewGuide,

              style: TextStyle(fontSize: 12, color: EgovColor.gray60),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _deleteMedia() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showPromptDialog(
      context,

      title: l10n.mediaServerDeleteTitle,
      message: l10n.mediaServerDeleteConfirm(widget.mediaFile.name),
      confirmText: l10n.mediaDelete,
      cancelText: l10n.mediaCancel,
    );

    if (confirmed != true) return;
    if (!mounted) return;

    await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
      context: context,
      operation: () async {
        final result = await _notifier.deleteMedia();
        if (!mounted) return;

        switch (result) {
          case MediaServerDeleteSuccess(:final message):
            await showStatusToast(
              context,
              variant: StatusVariant.success,
              title: l10n.commonSuccess,
              message:
                  '${resolveAppMessage(l10n, message)}: ${widget.mediaFile.name}',
            );

            if (!mounted) return;
            Navigator.pop(context, true);

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

    final detailState = ref.watch(mediaDetailProvider(widget.mediaFile));

    return ApiFeatureShell(
      popToApiMainCount: 2,
      feature: ApiFeature.media,

      title: l10n.mediaDetailTitle,

      mainFunctionBody: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            InfoBox(text: l10n.mediaDetailInfo),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,

                child: Column(
                  children: [
                    if (widget.mediaFile.type == MediaType.image ||
                        widget.mediaFile.type == MediaType.video)
                      _buildPreviewSection(),

                    CommonTable(
                      title: l10n.mediaDetailTableTitle,

                      data: [
                        {
                          'label': l10n.mediaLabelFileName,

                          'value': widget.mediaFile.name,
                        },

                        {
                          'label': l10n.mediaLabelFileSize,

                          'value': widget.mediaFile.formattedSize,
                        },

                        {
                          'label': l10n.mediaLabelType,

                          'value': widget.mediaFile.typeString,
                        },

                        if (widget.mediaFile.fileStreCours != null &&
                            widget.mediaFile.fileStreCours!.isNotEmpty)
                          {
                            'label': l10n.mediaLabelPath,

                            'value': widget.mediaFile.fileStreCours!,
                          },

                        if (widget.mediaFile.streFileNm != null &&
                            widget.mediaFile.streFileNm!.isNotEmpty)
                          {
                            'label': l10n.mediaLabelStoredName,

                            'value': widget.mediaFile.streFileNm!,
                          },
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomBar: BottomButtonRow(
        buttons: [
          CustomButton(
            text: l10n.mediaDownloadButton,

            onTap: detailState.isDownloading ? null : _downloadMedia,

            icon: detailState.isDownloading
                ? SizedBox(
                    width: 20,

                    height: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,

                      value: detailState.downloadProgress,

                      valueColor: const AlwaysStoppedAnimation<Color>(
                        EgovColor.white100,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.download,

                    color: EgovColor.white100,

                    size: 20,
                  ),

            normalColor: EgovColor.primary50,

            fontSize: 15,

            horizontalPadding: 12,
          ),

          CustomButton(
            text: l10n.mediaDelete,

            onTap: detailState.isLoading ? null : _deleteMedia,

            icon: detailState.isLoading
                ? const SizedBox(
                    width: 20,

                    height: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,

                      valueColor: AlwaysStoppedAnimation<Color>(
                        EgovColor.white100,
                      ),
                    ),
                  )
                : const Icon(Icons.delete, color: EgovColor.white100, size: 20),

            normalColor: EgovColor.danger50,
          ),
        ],
      ),
    );
  }
}
