import 'dart:async';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/media_preview_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 로컬·서버(URL) 비디오 재생 화면
class VideoPlayerScreen extends StatefulWidget {
  final MediaFileInfo videoFile;
  final String? videoUrl;

  const VideoPlayerScreen({super.key, required this.videoFile, this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _hideControlsTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  String? _resolvePlaybackUrl() {
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      return widget.videoUrl;
    }
    if (widget.videoFile.isServerFile) {
      return resolveServerMediaDownloadUrl(widget.videoFile);
    }
    return null;
  }

  Future<void> _initializeVideoPlayer() async {
    if (_isDisposed) return;

    try {
      final networkUrl = _resolvePlaybackUrl();
      if (networkUrl != null) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(networkUrl));
      } else {
        _controller = VideoPlayerController.file(File(widget.videoFile.path));
      }

      await _controller!.initialize();

      if (_isDisposed) {
        _controller?.dispose();
        return;
      }

      _totalDuration = _controller!.value.duration;
      _isPlaying = _controller!.value.isPlaying;
      _controller!.addListener(_videoListener);

      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialized = true;
        });
        _controller!.play();
      }
    } catch (_) {
      if (mounted && !_isDisposed) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _videoListener() {
    if (_controller != null && mounted && !_isDisposed) {
      setState(() {
        _currentPosition = _controller!.value.position;
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _hideControlsTimer?.cancel();

    if (_controller != null) {
      try {
        _controller!.removeListener(_videoListener);
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        }
        _controller!.dispose();
      } catch (_) {}
    }
    _controller = null;
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && !_isDisposed) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _showControlsTemporarily();
    }
  }

  void _showControlsTemporarily() {
    if (!_isDisposed && mounted) {
      setState(() {
        _showControls = true;
      });

      _hideControlsTimer?.cancel();
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDisposed && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _seekTo(Duration position) {
    if (_controller != null && !_isDisposed) {
      _controller!.seekTo(position);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Widget _buildVideoControls() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            EgovColor.black75,
            Colors.transparent,
            Colors.transparent,
            EgovColor.black75,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: _popAfterCleanup,
                  icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
                ),
                Expanded(
                  child: Text(
                    widget.videoFile.name,
                    style: const TextStyle(
                      color: EgovColor.white100,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: EgovColor.white100,
                    inactiveTrackColor: EgovColor.white50,
                    thumbColor: EgovColor.white100,
                    overlayColor: EgovColor.white25,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: _currentPosition.inMilliseconds.toDouble(),
                    max: _totalDuration.inMilliseconds > 0
                        ? _totalDuration.inMilliseconds.toDouble()
                        : 1,
                    onChanged: (value) {
                      _seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: EgovText.bodySmall.copyWith(
                        color: EgovColor.white100,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDuration(_totalDuration),
                      style: EgovText.bodySmall.copyWith(
                        color: EgovColor.white100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cleanupVideo() async {
    if (_controller != null && !_isDisposed) {
      try {
        if (_controller!.value.isInitialized && _controller!.value.isPlaying) {
          await _controller!.pause();
        }
        await Future.delayed(const Duration(milliseconds: 150));
      } catch (_) {}
    }
  }

  Future<void> _popAfterCleanup() async {
    await _cleanupVideo();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          await _popAfterCleanup();
        }
      },
      child: Scaffold(
        backgroundColor: EgovColor.gray100,
        appBar: AppBar(
          backgroundColor: EgovColor.gray100,
          foregroundColor: EgovColor.white100,
          title: Text(widget.videoFile.name),
        ),
        body: Center(
          child: _hasError
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      size: 64,
                      color: EgovColor.white100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.mediaVideoPlayError,
                      style: EgovText.regular.copyWith(
                        color: EgovColor.white100,
                      ),
                    ),
                  ],
                )
              : !_isInitialized
              ? const CircularProgressIndicator()
              : GestureDetector(
                  onTap: () {
                    if (_showControls) {
                      setState(() {
                        _showControls = false;
                      });
                      _hideControlsTimer?.cancel();
                    } else {
                      _showControlsTemporarily();
                    }
                  },
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                      if (_showControls) _buildVideoControls(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
