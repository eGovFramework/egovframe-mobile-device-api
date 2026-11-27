import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/media_preview_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 서버에 저장된 이미지·비디오 미리보기 썸네일
class ServerMediaThumbnail extends StatelessWidget {
  final MediaFileInfo mediaFile;
  final BoxFit fit;
  final int thumbnailMaxWidth;
  final bool showVideoPlayOverlay;

  const ServerMediaThumbnail({
    super.key,
    required this.mediaFile,
    this.fit = BoxFit.cover,
    this.thumbnailMaxWidth = 320,
    this.showVideoPlayOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final downloadUrl = resolveServerMediaDownloadUrl(mediaFile);
    if (downloadUrl == null) {
      return MediaThumbnailPlaceholder(type: mediaFile.type);
    }

    switch (mediaFile.type) {
      case MediaType.image:
        return _buildImagePreview(downloadUrl);
      case MediaType.video:
        return _buildVideoPreview(downloadUrl);
      default:
        return MediaThumbnailPlaceholder(type: mediaFile.type);
    }
  }

  Widget _buildImagePreview(String url) {
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: EgovColor.gray10,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) =>
          const MediaThumbnailPlaceholder(type: MediaType.image),
    );
  }

  Widget _buildVideoPreview(String url) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        VideoThumbnailPreview(
          videoUrl: url,
          fit: fit,
          maxWidth: thumbnailMaxWidth,
        ),
        if (showVideoPlayOverlay) Center(child: _playOverlay()),
      ],
    );
  }

  Widget _playOverlay() {
    return const SizedBox(
      width: 28,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: EgovColor.black50,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(Icons.play_arrow, color: EgovColor.white100, size: 16),
        ),
      ),
    );
  }
}

class MediaThumbnailPlaceholder extends StatelessWidget {
  final MediaType type;

  const MediaThumbnailPlaceholder({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color background;
    final Color iconColor;

    switch (type) {
      case MediaType.image:
        icon = Icons.image;
        background = EgovColor.point50;
        iconColor = EgovColor.white100;
      case MediaType.video:
        icon = Icons.videocam;
        background = EgovColor.secondary50;
        iconColor = EgovColor.white100;
      default:
        icon = Icons.insert_drive_file;
        background = EgovColor.gray10;
        iconColor = EgovColor.gray40;
    }

    return Container(
      color: background,
      child: Center(child: Icon(icon, color: iconColor, size: 28)),
    );
  }
}

/// 로컬·서버(URL) 비디오의 첫 프레임 썸네일을 비동기로 표시
class VideoThumbnailPreview extends StatefulWidget {
  final String? videoPath;
  final String? videoUrl;
  final BoxFit fit;
  final int maxWidth;

  const VideoThumbnailPreview({
    super.key,
    this.videoPath,
    this.videoUrl,
    this.fit = BoxFit.cover,
    this.maxWidth = 320,
  }) : assert(videoPath != null || videoUrl != null);

  @override
  State<VideoThumbnailPreview> createState() => _VideoThumbnailPreviewState();
}

class _VideoThumbnailPreviewState extends State<VideoThumbnailPreview> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  @override
  void didUpdateWidget(VideoThumbnailPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath ||
        oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _failed = false;
      _loadPreview();
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _loadPreview() async {
    if (widget.videoPath != null) {
      final videoFile = File(widget.videoPath!);
      if (!await videoFile.exists()) {
        if (mounted) setState(() => _failed = true);
        return;
      }
    }

    try {
      final controller = widget.videoUrl != null
          ? VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
          : VideoPlayerController.file(File(widget.videoPath!));

      await controller.initialize();
      await controller.seekTo(Duration.zero);
      await controller.pause();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return FittedBox(
        fit: widget.fit,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      );
    }

    if (_failed) {
      return _fallback();
    }

    return Container(
      color: EgovColor.gray10,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: EgovColor.gray10,
      child: const Icon(Icons.videocam, size: 32, color: EgovColor.gray30),
    );
  }
}
