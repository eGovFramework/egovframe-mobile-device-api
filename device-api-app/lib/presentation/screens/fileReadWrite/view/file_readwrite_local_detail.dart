import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileReadWrite/entities/file_readwrite_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view_model/file_readwrite_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/file_display_util.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/api_feature_shell_config.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/media_thumbnail.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view/media_main.dart'
    show ImageViewScreen;
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view/video_player_screen.dart';

class FileReadWriteLocalDetailPage extends ConsumerStatefulWidget {
  final FileInfo localFile;

  const FileReadWriteLocalDetailPage({super.key, required this.localFile});

  @override
  ConsumerState<FileReadWriteLocalDetailPage> createState() =>
      _FileReadWriteLocalDetailPageState();
}

class _FileReadWriteLocalDetailPageState
    extends ConsumerState<FileReadWriteLocalDetailPage> {
  bool _isLoading = false;
  bool _isDeleting = false;
  String? _textContent;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    if (FileDisplayUtil.isTextPreviewFile(widget.localFile.fileName)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadTextContent());
    }
  }

  Future<void> _loadTextContent() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    final result = await ref
        .read(fileReadWriteMainProvider.notifier)
        .readFileByPath(
          filePath: widget.localFile.filePath,
          fileName: widget.localFile.fileName,
        );

    if (!mounted) return;

    switch (result) {
      case FileReadWriteReadSuccess(:final content):
        setState(() {
          _isLoading = false;
          _textContent = content;
        });
      case FileReadWriteReadFailure(:final message):
        setState(() {
          _isLoading = false;
          _loadError = message;
        });
    }
  }

  void _openImagePreview() {
    final mediaFile = FileDisplayUtil.toMediaFileInfo(widget.localFile);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewScreen(imageFile: mediaFile),
      ),
    );
  }

  void _playVideo() {
    final mediaFile = FileDisplayUtil.toMediaFileInfo(widget.localFile);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: mediaFile),
      ),
    );
  }

  Future<void> _deleteFile() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPromptDialog(
      context,
      title: l10n.fileReadWriteDeleteTitle,
      message: l10n.fileReadWriteLocalDeleteConfirm(widget.localFile.fileName),
      confirmText: l10n.commonDelete,
      cancelText: l10n.fileReadWriteCancelButton,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);
    final result = await ref
        .read(fileReadWriteMainProvider.notifier)
        .deleteFile(widget.localFile.fileName);
    if (!mounted) return;
    setState(() => _isDeleting = false);

    switch (result) {
      case FileReadWriteDeleteSuccess(:final fileName):
        await showStatusToast(
          context,
          variant: StatusVariant.success,
          title: l10n.commonSuccess,
          message: l10n.fileReadWriteLocalDeleteSuccess(fileName),
        );
        if (mounted) Navigator.pop(context, true);
      case FileReadWriteDeleteFailure(:final message):
        await showStatusToast(
          context,
          variant: StatusVariant.error,
          title: l10n.commonError,
          message: resolveAppMessage(l10n, message),
        );
    }
  }

  Widget _previewContainer({
    required Widget child,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    bool scrollable = false,
    double? height = 200,
  }) {
    final body = padding == EdgeInsets.zero
        ? child
        : Padding(padding: padding, child: child);
    return Container(
      width: double.infinity,
      height: height,
      constraints: height == null
          ? const BoxConstraints(maxHeight: 240)
          : null,
      decoration: BoxDecoration(
        color: EgovColor.gray5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EgovColor.gray20),
      ),
      clipBehavior: Clip.antiAlias,
      child: scrollable ? SingleChildScrollView(child: body) : body,
    );
  }

  Widget _previewBlock({
    required String title,
    required Widget preview,
    String? guide,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: EgovColor.gray80,
            ),
          ),
          const SizedBox(height: 8),
          preview,
          if (guide != null) ...[
            const SizedBox(height: 6),
            Text(
              guide,
              style: const TextStyle(fontSize: 12, color: EgovColor.gray60),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    final l10n = AppLocalizations.of(context)!;
    final fileName = widget.localFile.fileName;
    final title = l10n.fileReadWritePreviewTitle;

    if (FileDisplayUtil.isImageFile(fileName)) {
      return _previewBlock(
        title: title,
        guide: l10n.fileReadWriteImagePreviewGuide,
        preview: GestureDetector(
          onTap: _openImagePreview,
          child: _previewContainer(
            height: null,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.file(
                File(widget.localFile.filePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 48,
                    color: EgovColor.gray40,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (FileDisplayUtil.isVideoFile(fileName)) {
      return _previewBlock(
        title: title,
        guide: l10n.fileReadWriteVideoPreviewGuide,
        preview: GestureDetector(
          onTap: _playVideo,
          child: _previewContainer(
            height: null,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoThumbnailPreview(videoPath: widget.localFile.filePath),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: EgovColor.black50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: EgovColor.white100,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_isLoading) {
      return _previewBlock(
        title: title,
        preview: _previewContainer(
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_loadError != null) {
      return _previewBlock(
        title: title,
        preview: _previewContainer(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Text(
              resolveAppMessage(l10n, _loadError!),
              style: const TextStyle(color: EgovColor.danger50),
            ),
          ),
        ),
      );
    }

    if (_textContent != null) {
      return _previewBlock(
        title: title,
        preview: _previewContainer(
          padding: const EdgeInsets.all(12),
          scrollable: true,
          child: Text(
            _textContent!,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      );
    }

    return _previewBlock(
      title: title,
      preview: _previewContainer(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            l10n.fileReadWritePreviewNotSupported,
            style: const TextStyle(color: EgovColor.gray60),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ApiFeatureShell(
      popToApiMainCount: 1,
      feature: ApiFeature.fileReadWrite,
      title: l10n.fileReadWriteLocalDetailTitle,
      mainFunctionBody: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoBox(text: l10n.fileReadWriteLocalDetailInfo),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPreviewSection(),
                    CommonTable(
                      title: l10n.fileReadWriteDetailTableTitle,
                      data: [
                        {
                          'label': l10n.fileReadWriteLabelFileName,
                          'value': widget.localFile.fileName,
                        },
                        {
                          'label': l10n.fileReadWriteLabelPath,
                          'value': widget.localFile.filePath,
                        },
                        {
                          'label': l10n.fileReadWriteLabelSize,
                          'value': widget.localFile.formattedSize,
                        },
                        {
                          'label': l10n.fileReadWriteLabelModifiedAt,
                          'value': widget.localFile.formattedDate,
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
            text: l10n.commonDelete,
            onTap: _isDeleting ? null : _deleteFile,
            icon: _isDeleting
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
