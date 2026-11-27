import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 네트워크 동영상 스트리밍 재생 화면
class StreamingVideoPlayerPage extends StatefulWidget {
  final String title;
  final String videoUrl;

  const StreamingVideoPlayerPage({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  @override
  State<StreamingVideoPlayerPage> createState() =>
      _StreamingVideoPlayerPageState();
}

class _StreamingVideoPlayerPageState extends State<StreamingVideoPlayerPage> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();

      if (!mounted) return;

      _totalDuration = _controller!.value.duration;
      _isPlaying = _controller!.value.isPlaying;
      _controller!.addListener(_videoListener);

      setState(() {
        _isInitialized = true;
      });
      await _controller!.play();
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _videoListener() {
    if (_controller != null && mounted) {
      setState(() {
        _currentPosition = _controller!.value.position;
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    if (_isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    _showControlsTemporarily();
  }

  void _showControlsTemporarily() {
    setState(() => _showControls = true);
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _seekTo(Duration position) {
    _controller?.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: EgovColor.gray100,
      appBar: AppBar(
        backgroundColor: EgovColor.gray100,
        foregroundColor: EgovColor.white100,
        title: Text(widget.title),
      ),
      body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: EgovColor.white100),
                  const SizedBox(height: 16),
                  Text(
                    l10n.streamingVideoPlayError,
                    style: EgovText.regular.copyWith(color: EgovColor.white100),
                  ),
                ],
              )
            : !_isInitialized
            ? const CircularProgressIndicator()
            : GestureDetector(
                onTap: () {
                  if (_showControls) {
                    setState(() => _showControls = false);
                    _hideControlsTimer?.cancel();
                  } else {
                    _showControlsTemporarily();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    if (_showControls)
                      Positioned.fill(
                        child: DecoratedBox(
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
                              const Spacer(),
                              IconButton(
                                onPressed: _togglePlayPause,
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Slider(
                                      value: _currentPosition.inMilliseconds
                                          .toDouble(),
                                      max: _totalDuration.inMilliseconds > 0
                                          ? _totalDuration.inMilliseconds
                                                .toDouble()
                                          : 1,
                                      onChanged: (value) {
                                        _seekTo(
                                          Duration(milliseconds: value.toInt()),
                                        );
                                      },
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
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
